//
//  AlbumModel.swift
//  TTImagePicker
//
//  Created by TYQ on 2021/11/22.
//

import UIKit
import Photos

class AlbumData:NSObject{
    // 所有相片资源
    var data = [AlbumModel]()
    // 选中的相片资源
    var selectData = [AlbumModel]()
}

class AlbumModel: NSObject { // 类的定义：如果类的所有成员都在定义的时候指定了初始值，编译器会为类自动生成一个无参的初始化器
    var asset: PHAsset?
    var thumbnailImage: UIImage?
    var highQualityImage: UIImage?
    // 是否被选中
    var isSelect = false
    // 选中照片当前数量的标记，默认为0
    var tag = 0
    // 未选中照片置灰标志
    var flag = false
    // 在相册预预览的地方记录当前照片在选中数组中的位置
    var currentSelect = false
    // 在相册中的位置
    var index = 0
}
