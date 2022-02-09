//
//  AssetSelectedCollectionViewCell.swift
//  TTImagePicker
//
//  Created by TYQ on 2022/1/25.
//

import UIKit

class AssetSelectedCollectionViewCell: UICollectionViewCell {
    
    lazy var imgV: UIImageView = {
        let imgV = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 60))
        imgV.contentMode = .scaleAspectFit
        imgV.isUserInteractionEnabled = true
        return imgV
    }()
    
    var albumModel: AlbumModel?{
        didSet{
            if let thumbnailImage = albumModel?.thumbnailImage  {
                self.imgV.image = thumbnailImage
            }
//            if let asset = albumModel?.asset  {
//                AlbumTool.setThumbnailImage(imageView: self.imgV, asset: asset)
//            }
            if albumModel?.currentSelect == true {
                self.layer.borderWidth = 4
                self.layer.borderColor = UIColor.init(hexString: TComplete).cgColor
            }else{
                self.layer.borderWidth = 0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imgV)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
