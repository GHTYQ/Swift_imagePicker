//
//  AlbumPreviewCollectionViewController.swift
//  TTImagePicker
//
//  Created by TYQ on 2021/12/31.
//

import UIKit

class AlbumPreviewCollectionViewController: BaseViewController, ProjectSelectNavigationVeiwDelegate {
    var isShowNav = true
    let nav = PreViewNavigationView()
    let tabbar = PreviewTabbarView()
    let assetSelectedCollectionV = AssetSelectedCollectionView()
    // 判断是否是全部选中的照片展示 默认的true
    var isAllSelected = true
    
    var albumData = AlbumData()
    // 当展示的是全部选中的照片的时候 data == selectData
    var data = [AlbumModel]()
    var selectData = [AlbumModel]()
    
    var currentIndex = 0

    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: SCREEN_WIDHT, height: SCREEN_HEIGHT)
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDHT, height: SCREEN_HEIGHT), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(AlbumPreviewCollectionViewCell.self, forCellWithReuseIdentifier: "preViewCellID")
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(hexString: TBLACK)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.addSubview(self.collectionView)
        self.nav.delegate = self
        self.view.addSubview(self.nav)
        self.view.addSubview(self.tabbar)
        self.collectionView.contentOffset = CGPoint.init(x: SCREEN_WIDHT*CGFloat(self.currentIndex), y: 0.0)
        self.assetSelectedCollectionV.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT - TABBAR_HEIGHT - 100, width: SCREEN_WIDHT, height: 100)
        self.assetSelectedCollectionV.delegate = self
        self.view.addSubview(self.assetSelectedCollectionV)
        
        // 初始化展示
        let currentModel = self.data[self.currentIndex]
        changeNavSelectImageViewShow(currentModel:currentModel)
        self.assetSelectedCollectionV.isAllSelected = self.isAllSelected
        if selectData.count >  0{
            // 设置tabbar上方预览
            self.assetSelectedCollectionV.isHidden = false
            for model in self.selectData {
                model.currentSelect = false
                if model == currentModel {
                    model.currentSelect = true
                }
            }
            self.assetSelectedCollectionV.selectData = self.selectData
            self.assetSelectedCollectionV.reload()
            
        }else{
            self.assetSelectedCollectionV.isHidden = true
        }
        
    }
    
}
//MARK: ColectionView 代理
extension AlbumPreviewCollectionViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "preViewCellID", for: indexPath) as! AlbumPreviewCollectionViewCell
        cell.albumModel = self.data[indexPath.row]
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {// 快速滑动的时候是有问题的
        self.currentIndex = Int(scrollView.contentOffset.x/SCREEN_WIDHT)
        let currentModel = self.data[self.currentIndex]
        changeNavSelectImageViewShow(currentModel: currentModel)
//        print(self.currentIndex,scrollView.contentOffset.x)
        // 找到当前显示的照片 并打上标签
        for model in self.selectData {
            model.currentSelect = false
            if model == currentModel {
                model.currentSelect = true
            }
        }
        self.assetSelectedCollectionV.reload()
        // 限制图片选中数量最多为9张，当大于9张的时候 选中按钮隐藏
        if self.selectData.count >= 9  && currentModel.isSelect == false{
            self.nav.selectBtn.isHidden = true
        }else{
            self.nav.selectBtn.isHidden = false
        }
    }
}
//MARK: 当前控制器方法
extension AlbumPreviewCollectionViewController{
    func changeNavigationShowStatus(){
        if self.isShowNav {
            self.nav.isHidden = true
            self.tabbar.isHidden = true
            self.isShowNav = false
        }else{
            self.nav.isHidden = false
            self.tabbar.isHidden = false
            self.isShowNav = true
        }
    }
    
    func changeNavSelectImageViewShow(currentModel: AlbumModel){
        if currentModel.isSelect {
            // 导航栏右按钮✅打上
            self.nav.isSelect = true
        }else{
            self.nav.isSelect = false
        }
    }
}

//MARK: 导航的代理方法
extension AlbumPreviewCollectionViewController: PreViewNavigationViewDelegate{
    func previewNavigationViewSelected(currentNav: PreViewNavigationView) {
        print("\(currentIndex)")
        // 判断当前的图片是否已经被选中，如果是已经被选中的则从selectData中将他们移除，如果是未被选中的则将当前视图添加到selectData
        // 获取当前视图
        let currentModel = self.data[self.currentIndex]
        // 判断当前视图的选中状态
        print(currentModel.isSelect)
        if currentModel.isSelect {
            for (index,model) in self.selectData.enumerated() {
                if model == currentModel {
                    // 选中数组中移除取消选中的图片
                    self.selectData.remove(at: index)
                }
            }
            // 所有大于当前图片tag的tag减一
            for model in self.data {
                if model.tag > 0 && model.tag >= currentModel.tag {
                    model.tag = model.tag - 1
                }
            }
            currentModel.isSelect = false
            currentModel.tag = 0
            self.nav.isSelect = false
        }else{
            currentModel.isSelect = true
            currentModel.tag = self.selectData.count + 1
            self.selectData.append(currentModel)
            self.nav.isSelect = true
        }
        // 找到当前显示的照片 并打上标签
        for model in self.selectData {
            model.currentSelect = false
            if model == currentModel {
                model.currentSelect = true
            }
        }
        // 数据同步
        self.albumData.data = self.data
        self.albumData.selectData = self.selectData
        self.assetSelectedCollectionV.selectData = self.selectData
        self.assetSelectedCollectionV.reload()
    }
}
//MARK: cell手势的代理方法
extension AlbumPreviewCollectionViewController: AlbumPreviewCollectionViewCellDelegate{
    func AlbumPreviewCollectionViewCellSingleTap(indexPath: IndexPath) {
        changeNavigationShowStatus()
    }
}

//MARK: AssetSelectedPreviewDelegate
extension AlbumPreviewCollectionViewController: AssetSelectedPreviewDelegate{
    func assetSelectedPreviewImageViewSelect(albumModel: AlbumModel) {
        var selectIndex: CGFloat
        if self.isAllSelected {
            selectIndex = CGFloat(albumModel.tag - 1)
            
        }else{
            selectIndex = CGFloat(albumModel.index)
        }
        self.collectionView.contentOffset = CGPoint.init(x: selectIndex*SCREEN_WIDHT, y: 0.0)
        for model in self.selectData {
            model.currentSelect = false
            if model == albumModel {
                model.currentSelect = true
            }
        }
        self.assetSelectedCollectionV.reload()
        
        // 判断当前屏幕下 最多放几个cell 目前每个cell+边距10后大小为70  40为collectionview 距离左右边框的的距离之和
        let maxCount = (SCREEN_WIDHT-40)/70
        print("maxCount",maxCount)
        // 计算当点击的位置大于最大位数一半的时候就位移
        let center = (maxCount/2.0 )
        // 当点击的位置大于最大个数一半的时候就让collectionview左移一个cell的大小
        if CGFloat(albumModel.tag) > center  {
            let offet = CGFloat(albumModel.tag) - center
            print("offet",offet)
            if offet+maxCount < CGFloat(self.selectData.count) {
                self.assetSelectedCollectionV.collectionView.contentOffset = CGPoint.init(x: 10.0 + offet * 70, y: 0)
            }
        }else{
            print("123123")
            self.assetSelectedCollectionV.collectionView.contentOffset = CGPoint.init(x: 0, y: 0)
        }
       
    }
}
