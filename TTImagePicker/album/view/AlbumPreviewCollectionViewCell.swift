//
//  AlbumPreviewCollectionViewCell.swift
//  TTImagePicker
//
//  Created by TYQ on 2021/12/31.
//

import UIKit

protocol AlbumPreviewCollectionViewCellDelegate: NSObjectProtocol{
    func AlbumPreviewCollectionViewCellSingleTap(indexPath: IndexPath)
}

class AlbumPreviewCollectionViewCell: UICollectionViewCell {
    lazy var imgV: UIImageView = {
        let imgV = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDHT, height: SCREEN_HEIGHT))
        imgV.contentMode = .scaleAspectFit
        imgV.isUserInteractionEnabled = true
        return imgV
    }()
    var albumModel: AlbumModel?{
        didSet{
//            if let highQualityImage = albumModel?.highQualityImage {
//                self.imgV.image = highQualityImage
//            } else if let asset = albumModel?.asset  {
//                AlbumTool.setHighQualityImage(imageView: self.imgV ,albumModel: albumModel!, asset: asset)
//
//            }
            if let asset = albumModel?.asset  {
                AlbumTool.setHighQualityImage(imageView: self.imgV ,albumModel: albumModel!, asset: asset)
            }
        }
    }
    var isTap = false
    var indexPath: IndexPath?
    weak var delegate: AlbumPreviewCollectionViewCellDelegate?
    override init(frame: CGRect) {
//        self.indexPath = indexPath
//        self.delegate = delegate
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(hexString: TBLACK)
        self.addSubview(imgV)
//        self.scrollV.addSubview(imgV)
        // 添加捏合手势
        let pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(onClickPinch))
        self.imgV.addGestureRecognizer(pinchGesture)
        
        // 添加单击手势
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(onClickSingleTap))
        self.imgV.addGestureRecognizer(singleTap)
        
        // 添加双击手势
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(onClickDoubleTap))
        /**
         numberOfTapsRequired：匹配所需的轻击数
         numberOfTouchesRequired: 匹配所需的手指数
         */
        doubleTap.numberOfTapsRequired = 2
        self.imgV.addGestureRecognizer(doubleTap)
        ///创建一个与另一个手势识别器的关系。当第一次点击的时候，单击手势的事件暂时不处理，只有确定不是双击手势的时候，才去响应单击手势的事件
        singleTap.require(toFail: doubleTap)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //捏合手势事件
    @objc func onClickPinch(recognizer: UIPinchGestureRecognizer){
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }
    //单击手势事件
    @objc func onClickSingleTap(recognizer: UITapGestureRecognizer){
        print("单击",recognizer.state)
        
        if let d = self.delegate, let indexPa = self.indexPath{
            d.AlbumPreviewCollectionViewCellSingleTap(indexPath: indexPa)
        }
    }
    //双击手势事件
    @objc func onClickDoubleTap(recognizer: UITapGestureRecognizer){
        print("双击")
        if let view = recognizer.view {
            if self.isTap == false {
                view.transform = view.transform.scaledBy(x: 2, y: 2)
                self.isTap = true
            }else{
                view.transform = view.transform.scaledBy(x: 0.5, y: 0.5)
                self.isTap = false
            }
            
        }
    }
}
