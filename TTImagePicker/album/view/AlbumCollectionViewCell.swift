//
//  AlbumCollectionViewCell.swift
//  TTImagePicker
//
//  Created by TYQ on 2021/11/19.
//

import UIKit
import Photos

// 1/定义协议
protocol AlbumCollectionCellDelegate: NSObjectProtocol {
    // 2.定义协议方法
    func AlbumCollectionCllSelectButtonClcik(currentIndex:Int, numLabel: UILabel, albumModel:AlbumModel)
}

class AlbumCollectionViewCell: UICollectionViewCell {
    // 2.声明代理属性（使用weak修饰，且该协议需要继承NSObjectProtocol基协议）
    weak var delegete: AlbumCollectionCellDelegate?
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var numLab: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    var currentIndex: Int?
    fileprivate let imageManager = PHCachingImageManager()
    var albumModel: AlbumModel?{
        didSet{
            if let thumbnailImage = albumModel?.thumbnailImage {
                self.imgV.image = thumbnailImage
            }else if let asset = albumModel?.asset  {
                AlbumTool.setThumbnailImage(imageView: self.imgV, albumModel: albumModel!, asset: asset)
              
            }
//            if let asset = albumModel?.asset  {
//                AlbumTool.setThumbnailImage(imageView: self.imgV, asset: asset)
//            }
            if albumModel?.isSelect == true {
                self.numLab.isHidden = false
                if let tag = albumModel?.tag {
                    self.numLab.text = String(tag)
                }
                self.selectBtn.setImage(UIImage.init(named: "circle_select"), for: .normal)
                self.frontView.backgroundColor = UIColor.init(hexString: TBLACK, alpha: 0.2)
            }else{
                self.numLab.isHidden = true
                self.selectBtn.setImage(UIImage.init(named: "circle"), for: .normal)
                self.frontView.backgroundColor = UIColor.clear
            }
            if albumModel?.flag == true && albumModel?.isSelect == false {
                self.frontView.backgroundColor = UIColor.init(hexString: TBLACK, alpha: 0.6)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.init(hexString: TBLACK)
        self.selectBtn.layer.cornerRadius = 10
        self.imgV.contentMode = .scaleAspectFill
        self.imgV.isUserInteractionEnabled = true
    }
    
    
    @IBAction func selectBtnClick(_ sender: UIButton) {
        delegete?.AlbumCollectionCllSelectButtonClcik(currentIndex:self.currentIndex ?? 0,numLabel: self.numLab, albumModel: self.albumModel!)
    }
}
