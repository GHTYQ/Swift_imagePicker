//
//  AlbumTool.swift
//  TTImagePicker
//
//  Created by TYQ on 2021/12/31.
//

import UIKit
import Photos

enum Quality {
    case thumbnail
    case high
}

class AlbumTool: NSObject {
    let itemWidth = (SCREEN_WIDHT-10)/4.0
    let thumbnailScale = UIScreen.main.scale
    //static和class 这两个关键字都是用来说明被修饰的属性或者方法是类型(class/struct/enum)的,而不是类型实例的
    //static适用场景：1.修饰存储属性 2.修饰计算属性 3.修饰类方法
    //class 适用场景：1.修饰计属性 2.修饰类方法
    //static修饰的类方法不能继承，class修饰的类方法可以继承
    //class不能修饰类的存储属性，static可以修饰类的存储属性
    static let thumbnailSize = CGSize.init(width: (SCREEN_WIDHT-10)/4.0 * UIScreen.main.scale, height: (SCREEN_WIDHT-10)/4.0 * UIScreen.main.scale)
    static let highQualitySize = CGSize.init(width: SCREEN_WIDHT * UIScreen.main.scale, height: SCREEN_HEIGHT * UIScreen.main.scale)
    

}
// 根据Asset 获取iamge
extension AlbumTool{
    // 让视图显示缩略图
    static func setThumbnailImage(imageView: UIImageView, albumModel: AlbumModel, asset: PHAsset){
        PHImageManager.default().requestImage(for: asset, targetSize: self.thumbnailSize , contentMode: .aspectFit, options: nil, resultHandler: {(image, _) in
            imageView.image = image
            albumModel.thumbnailImage = image
        })
    }
    
    // 让视图显示高清图
    static func setHighQualityImage(imageView: UIImageView, albumModel: AlbumModel, asset: PHAsset){
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        PHImageManager.default().requestImage(for: asset, targetSize: highQualitySize , contentMode: .aspectFit, options: options, resultHandler: {(image, _) in
            imageView.image = image
            albumModel.highQualityImage = image
        })
    }
}
// 根据 PHAssetCollection 获取Asset
extension AlbumTool{
    static func getAsset(from assetCollection: PHAssetCollection) -> PHFetchResult<PHAsset>!{
        return PHAsset.fetchAssets(in: assetCollection, options: nil)
    }
}
