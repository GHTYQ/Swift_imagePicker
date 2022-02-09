//
//  NavigationView.swift
//  TTImagePicker
//
//  Created by TYQ on 2021/11/30.
//

import UIKit

@objc protocol ProjectSelectNavigationVeiwDelegate:NSObjectProtocol {
    @objc optional  func projectSelectNavigationVeiwItemSelect(currentNav: ProjectSelectNavigationVeiw,showList: Bool)
   
}

@objc protocol PreViewNavigationViewDelegate:NSObjectProtocol{
    @objc optional  func previewNavigationViewSelected(currentNav: PreViewNavigationView)
}

class NavigationView: UIView {


}

// 项目选择 导航
class ProjectSelectNavigationVeiw:UIView{
    weak var delegate: ProjectSelectNavigationVeiwDelegate?
    // 控制项目选择右边按钮的朝向,默认是不展示相册列表
    var showList = false
    // 叉号
    lazy var closedBtn: UIButton = {
        let closedBtn = UIButton()
        closedBtn.setBackgroundImage(UIImage.init(named: "closed"), for: .normal)
        closedBtn.addTarget(self, action: #selector(closedBtnClick), for: .touchUpInside)
        return closedBtn
    }()
    // 项目选择 bg #4B4B4B
    lazy var selectBtn: UIButton = {
        let selectBtn = UIButton()
        selectBtn.backgroundColor = UIColor.init(hexString: "#4B4B4B")
        selectBtn.layer.cornerRadius = 18
        // 项目选择 箭头
        let selectImgV = UIImageView()
        selectImgV.image = UIImage.init(named:"downArrow")
        selectImgV.tag = 10
        selectBtn.addSubview(selectImgV)
        
        selectImgV.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 23, height: 20))
        }
        return selectBtn
    }()
    
    lazy var selectLab: UILabel = {
        // 项目选择 文字
        var selectLab = UILabel()
        selectLab.text = "项目选择"
        selectLab.textAlignment = .right
        selectLab.textColor = UIColor.init(hexString: "#E6E6E6")
        selectLab.font = TSFont17
        return selectLab
    }()

    override init(frame: CGRect){
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDHT, height: NAVBAR_HEIGHT)
        self.backgroundColor =  TNav_Color
        setSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubViews(){
        // 叉号
        self.addSubview(self.closedBtn)
        
        self.closedBtn.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.bottom.equalTo(-15)
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        }
        // 项目选择
        self.addSubview(self.selectBtn)
        self.selectBtn.addTarget(self, action: #selector(selectBtnClick), for: .touchUpInside)
        
        self.selectBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closedBtn)
            make.size.equalTo(CGSize.init(width: 125, height: 36))
        }
        self.selectBtn.addSubview(self.selectLab)
        selectLab.snp.makeConstraints { make in
            make.right.equalTo(-33-10)
            make.centerY.equalToSuperview()
        }
    }
    
    // 叉号点击事件
    @objc func closedBtnClick(){
        Global.currentViewController()?.dismiss(animated: true, completion: nil)
    }
    // 项目选择点击事件
    @objc func selectBtnClick(){
        let imgV = self.viewWithTag(10) as! UIImageView
        if(self.showList == false){
            self.showList = true
            // 点击的时候顺时针旋转180
            UIView.animate(withDuration: 0.5) {
                imgV.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        }else{
            self.showList = false
            // 点击的时候顺时针旋转180
            UIView.animate(withDuration: 0.5) {
                imgV.transform = CGAffineTransform(rotationAngle: CGFloat.pi*2)
            }
        }
        self.delegate?.projectSelectNavigationVeiwItemSelect?(currentNav: self, showList: showList)
    }
}
// 照片预览 导航
class PreViewNavigationView:UIView{
    weak var delegate: PreViewNavigationViewDelegate?
    // 返回按钮
    lazy var backBtn: UIButton = {
        let backBtn = UIButton()
        backBtn.setBackgroundImage(UIImage.init(named: "nav_back"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        return backBtn
    }()
    // 选中按钮
    lazy var selectBtn:UIButton = {
        let selectBtn = UIButton()
        selectBtn.setBackgroundImage(UIImage.init(named: "nav_complete"), for: .normal)
        selectBtn.addTarget(self, action: #selector(selectBtnClick), for: .touchUpInside)
        return selectBtn
    }()
    // 是否显示选中按钮✅
    var isSelect = false {
        didSet {
            if isSelect == true {
                self.selectBtn.setBackgroundImage(UIImage.init(named: "circle_select"), for: .normal)
            }else{
                self.selectBtn.setBackgroundImage(UIImage.init(named: "nav_complete"), for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDHT, height: NAVBAR_HEIGHT)
        self.backgroundColor = TNav_Color_alpha8
        setSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setSubViews(){
        // 返回
        self.addSubview(self.backBtn)
        
        self.backBtn.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.bottom.equalTo(-15)
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        }
        // 完成按钮
        self.addSubview(self.selectBtn)
        
        self.selectBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.backBtn)
            make.right.equalTo(-20)
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        }
    }
    
    @objc func backBtnClick(){
        print("返回")
        Global.currentViewController()?.dismiss(animated: true, completion: nil)
    }
    
    @objc func selectBtnClick(){
        print("选中✅")
        self.delegate?.previewNavigationViewSelected?(currentNav: self)
    }
}









