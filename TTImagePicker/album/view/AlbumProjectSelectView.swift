//
//  AlbumProjectSelectView.swift
//  TTImagePicker
//
//  Created by TYQ on 2022/1/6.
//

import UIKit
import Photos

protocol AlbumProjectSelectViewDelegate:NSObjectProtocol {
    func albumProjectSelectViewDidSelected(_ assets: PHFetchResult<PHAsset>!, title:String)
}

class AlbumProjectSelectView: UIView {
    let projectSelectCellID = "projectSelectCellID"
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var userCollections: PHFetchResult<PHCollection>!
    var resource = [PHFetchResult<PHAsset>?]()
    var collectionTitles = [String]()
    weak var delegates: AlbumProjectSelectViewDelegate?
    lazy var tableV: UITableView = {
        let tableV = UITableView.init(frame: CGRect.init(x: 0, y: 0.15, width: SCREEN_WIDHT, height: SCREEN_HEIGHT - NAVBAR_HEIGHT - TABBAR_HEIGHT - 50))
        tableV.register(UINib.init(nibName: "AlbumProjectSelectTableViewCell", bundle: nil), forCellReuseIdentifier: projectSelectCellID)
        tableV.backgroundColor = TNav_Color
        return tableV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: NAVBAR_HEIGHT, width: SCREEN_WIDHT, height: SCREEN_HEIGHT - NAVBAR_HEIGHT - TABBAR_HEIGHT)
        self.backgroundColor = UIColor.init(hexString: TBLACK, alpha: 0.6)
        self.resource.removeAll()
        self.collectionTitles.removeAll()
        self.tableV.delegate = self
        self.tableV.dataSource = self
        self.addSubview(self.tableV)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AlbumProjectSelectView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.smartAlbums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: projectSelectCellID, for: indexPath) as! AlbumProjectSelectTableViewCell
        let collection = self.smartAlbums[indexPath.row]
        // 相册名字
        cell.typeLab.text = collection.localizedTitle
        self.collectionTitles.append(collection.localizedTitle!)
        let assets: PHFetchResult<PHAsset>!
        assets = AlbumTool.getAsset(from: collection)
        self.resource.append(assets)
        // 数量
        cell.numLab.text = String("(\(assets.count))")
        // 缩略图
        cell.thumbnail.contentMode = .scaleAspectFill
        if let asset = assets.lastObject {
//            AlbumTool.setThumbnailImage(imageView: cell.thumbnail, asset: asset)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // remove 当前视图 将选中的项目对应的数据传到AlbumViewController
        if let d = self.delegates {
            d.albumProjectSelectViewDidSelected(self.resource[indexPath.row],title: self.collectionTitles[indexPath.row])
        }
        self.remove()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension AlbumProjectSelectView{
    func show(){
        if let vc = Global.currentViewController() {
            vc.view.addSubview(self)
        }
    }
    func remove(){
        self.removeFromSuperview()
    }
}
