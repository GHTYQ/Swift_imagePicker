//
//  Global.swift
//  TTImagePicker
//
//  Created by TYQ on 2021/11/18.
//

import UIKit

let SCREEN_WIDHT = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
// 状态栏高度
let STATUSBAR_HEIGHT = UIApplication.shared.statusBarFrame.height
//let stat = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height
// 状态栏+导航栏高度
let NAVBAR_HEIGHT = STATUSBAR_HEIGHT + 44.0
// 底部tabbar高度
let TABBAR_HEIGHT = STATUSBAR_HEIGHT > 20.0 ? 49.0 + 34.0 : 49.0

// 导航颜色
let TNav_Color = UIColor.init(hexString: "#3D3D3D", alpha: 1)
let TNav_Color_alpha8 = UIColor.init(hexString: "#3D3D3D", alpha: 0.8)
// 透明色
let TClear_Color = UIColor.clear
// 黑色
let TBLACK = "#000000"
// 白色
let TWHITE = "#ffffff"
// 相册选择字体颜色 预览 完成
let TPREVIEWFONT = "#646464"
// 弹窗背景颜色 RGB 44 44 44
let TBG = "#2C2C2C"
// 弹窗背景上横线颜色 RGB 47 47 47
let TLINE = "#2F2F2F"
// 弹窗上我知道了颜色 RGB 126 137 154
let TSURE = "#7E899A"
// 选中照片后 完成字体颜色
let TComplete = "#30AC59"


//字体
let TSFont17 = UIFont.systemFont(ofSize: 17)
