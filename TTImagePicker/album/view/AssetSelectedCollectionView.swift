//
//  AlbumSelectPreview.swift
//  TTImagePicker
//
//  Created by TYQ on 2021/12/28.
//

import UIKit

protocol AssetSelectedPreviewDelegate:NSObjectProtocol {
    func assetSelectedPreviewImageViewSelect(albumModel: AlbumModel)
}

// 这个view是AlbumPreviewViewController中的子view,在tabbar的正上方，存放的是选中的图片
class AssetSelectedCollectionView: UIView {

    var selectData = [AlbumModel]()
    // 判断是否是全部选中的照片展示 默认的true
    var isAllSelected = true
    
    weak var delegate: AssetSelectedPreviewDelegate?
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 60, height: 60)
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 20, y: 0, width: SCREEN_WIDHT - 40, height: 100), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AssetSelectedCollectionViewCell.self, forCellWithReuseIdentifier: "AssetSelectedCellID")
        return collectionView
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(hexString: "#222222")
        self.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDHT, height: 100)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.addSubview(self.collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reload(){
        self.collectionView.reloadData()
    }
}


extension AssetSelectedCollectionView: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssetSelectedCellID", for: indexPath) as! AssetSelectedCollectionViewCell
        cell.albumModel = self.selectData[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 获取当前点击图片的相关信息
        let albumModel = self.selectData[indexPath.row]
        self.delegate?.assetSelectedPreviewImageViewSelect(albumModel: albumModel)
    }
    
}
