//
//  AlbumViewController.swift
//  TTImagePicker
//
//  Created by TYQ on 2021/11/18.
//

import UIKit
import SnapKit
import Photos

//PHPhotoLibraryChangeObserver
class AlbumViewController: BaseViewController {
    var allPhotos: PHFetchResult<PHAsset>!
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var userCollections: PHFetchResult<PHCollection>!
    let sectionLocalizedTitles = ["", NSLocalizedString("Smart Albums", comment: ""), NSLocalizedString("Albums", comment: "")]
    
    fileprivate let imageManager = PHCachingImageManager()
    // 统一字体大小
    fileprivate let font = UIFont.systemFont(ofSize: 17)
    // 数据
    fileprivate var albumData = AlbumData()
    var nav = ProjectSelectNavigationVeiw()
    var tabbar = ProjectSelectTabbarView()
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.itemSize = CGSize(width: AlbumTool().itemWidth, height: AlbumTool().itemWidth)
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 1, y: NAVBAR_HEIGHT, width: SCREEN_WIDHT-2, height: SCREEN_HEIGHT-NAVBAR_HEIGHT-TABBAR_HEIGHT), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.init(hexString: TBLACK)
        collectionView.register(UINib.init(nibName: "AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellID")
        return collectionView
    }()
    
    lazy var projectSelectV:AlbumProjectSelectView = {
        let projectSelectV = AlbumProjectSelectView()
        return projectSelectV
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // bg #323232
        self.nav.delegate = self
        self.tabbar.delegate = self
        self.view.addSubview(self.nav)
        self.view.addSubview(self.tabbar)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.addSubview(collectionView)
        getAssets()
    }
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.albumData.selectData)
        self.collectionView.reloadData()
        if self.albumData.selectData.count > 0 {
            self.tabbar.changeStatus(showType: .white, count: self.albumData.selectData.count)
        }else{
            self.tabbar.changeStatus(showType: .gray, count: 0)
        }
    }
}
// MARK: NavigationViewDelegate
extension AlbumViewController:ProjectSelectNavigationVeiwDelegate,ProjectSelectTabbarViewDelegate{
    
   // 项目选择

    func projectSelectNavigationVeiwItemSelect(currentNav: ProjectSelectNavigationVeiw, showList: Bool) {
        if self.userCollections.count > 0 {
            self.projectSelectV.userCollections = self.userCollections
        }
        if self.smartAlbums.count > 0 {
            self.projectSelectV.smartAlbums = self.smartAlbums
        }
        if showList {
            self.projectSelectV.show()
        }else{
            self.projectSelectV.remove()
        }
    }
    // 预览
    func projectSelectTabbarViewPreview(currentTab: ProjectSelectTabbarView) {
        let previewVC = AlbumPreviewCollectionViewController()
        previewVC.modalPresentationStyle = .fullScreen
        previewVC.data = self.albumData.selectData
        previewVC.selectData = self.albumData.selectData
        previewVC.currentIndex = 0
        previewVC.albumData = self.albumData
        self.present(previewVC, animated: true, completion: nil)
    }
    
    // 完成
    func projectSelectTabbarViewComplete(currentTab: ProjectSelectTabbarView) {
    }
    
  
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension AlbumViewController:UICollectionViewDelegate, UICollectionViewDataSource, AlbumCollectionCellDelegate{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumData.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! AlbumCollectionViewCell
        cell.delegete = self
        cell.currentIndex = indexPath.row
        cell.albumModel = self.albumData.data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击cell")
        let previewVC = AlbumPreviewCollectionViewController()
        
        #warning("这里回来处理下present的转场动画，实现微信朋友圈照片选择的效果")
        previewVC.modalPresentationStyle = .fullScreen
        //判断当前点击的照片是否已经被选中，如果已经被选中，预览的时候只能显示所有被选中的照片，否则显示所有照片
        let model = self.albumData.data[indexPath.row]
        print("点击了第\(indexPath.row)个")
        if self.albumData.selectData.count > 0 && model.tag != 0 {
            // 点击已选中照片
            previewVC.isAllSelected = true
            previewVC.data = self.albumData.selectData
            previewVC.currentIndex = model.tag - 1
        }else{
            // 点击未选中的照片
            previewVC.isAllSelected = false
            previewVC.data = self.albumData.data
            previewVC.currentIndex = indexPath.row
        }
        previewVC.selectData = self.albumData.selectData
        previewVC.albumData = self.albumData
        self.present(previewVC, animated: true, completion: nil)
    }
    
    func AlbumCollectionCllSelectButtonClcik(currentIndex: Int, numLabel: UILabel, albumModel: AlbumModel) {
        
        if albumModel.isSelect{
            for (index,model) in self.albumData.selectData.enumerated() {
                if model == albumModel{
                    // 从选中的数组中移除被反选的照片
                    self.albumData.selectData.remove(at: index)
                }
            }
            // 其他选中的照片标号减一
            for model in self.albumData.data {
                if model.tag > 0 &&  model.tag > albumModel.tag {
                    model.tag = model.tag - 1
                }
            }
            
            albumModel.tag = 0
            albumModel.isSelect = false
            // 所有置灰全部清楚
            for model  in self.albumData.data {
                model.flag = false
            }
        }else{
            // 判断是否超过九张 超过后出选中照片其余全部置灰
            if self.albumData.selectData.count >= 9{
                for model in self.albumData.data {
                    for selectModel in self.albumData.selectData {
                        if model != selectModel {
                            model.flag = true
                        }
                    }
                }
                self.collectionView.reloadData()
                print("最多只能选择9张")
                ToastView.showToast()
                return
            }
            albumModel.tag = self.albumData.selectData.count+1
            albumModel.isSelect = true
            self.albumData.selectData.append(albumModel)
        }
        self.collectionView.reloadData()
        // 选中照片的时候 预览和完成按钮颜色变为白色
        if self.albumData.selectData.count > 0 {
            self.tabbar.changeStatus(showType: .white, count: self.albumData.selectData.count)
        }else{
            self.tabbar.changeStatus(showType: .gray, count: 0)
        }
    }
}

// MARK: 相册相关内容
extension AlbumViewController{
    func getAssets(){
        PHPhotoLibrary.shared().register(self)
        PHPhotoLibrary.requestAuthorization { status in
            if status != .authorized {
                print("没有权限")
                return
            }
        }
        let allPhotosOptions = PHFetchOptions()
        //按照创建时间
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        self.allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        /**
         album:自己创建的相册
         smartAlbum: 经由系统相机得来的相册
         moment: 自动生成的时间分组的相册
         */
        self.smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        self.userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        getAlbumData(with: self.allPhotos)
    }
    
    func getAlbumData(with asstes:PHFetchResult<PHAsset>!){
        self.albumData.data.removeAll()
        self.albumData.selectData.removeAll()
        for index in 0..<asstes.count {
            // 获取一个资源(PHAsset)
            let asset = asstes[index]
            let albumModel = AlbumModel()
            albumModel.asset = asset
            albumModel.index = index
            self.albumData.data.append(albumModel)
        }
        self.collectionView.reloadData()
        let indexPath = NSIndexPath.init(row: asstes.count - 1, section: 0)
        self.collectionView.scrollToItem(at: indexPath as IndexPath, at:.bottom, animated: false)
    }
}
//MARK: PHPhotoLibraryChangeObserver代理实现，图片新增、删除、修改开始后会触发
extension AlbumViewController: PHPhotoLibraryChangeObserver{
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.sync {
            // Check each of the three top-level fetches for changes.
            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
                // Update the cached fetch result.
                self.allPhotos = changeDetails.fetchResultAfterChanges
                // Don't update the table row that always reads "All Photos."
            }
            
//            // Update the cached fetch results, and reload the table sections to match.
//            if let changeDetails = changeInstance.changeDetails(for: smartAlbums) {
//                smartAlbums = changeDetails.fetchResultAfterChanges
//                tableView.reloadSections(IndexSet(integer: Section.smartAlbums.rawValue), with: .automatic)
//            }
//            if let changeDetails = changeInstance.changeDetails(for: userCollections) {
//                userCollections = changeDetails.fetchResultAfterChanges
//                tableView.reloadSections(IndexSet(integer: Section.userCollections.rawValue), with: .automatic)
//            }
        }
    }

}
