//
//  TabbarView.swift
//  TTImagePicker
//
//  Created by TYQ on 2021/11/30.
//

import UIKit
@objc protocol ProjectSelectTabbarViewDelegate:NSObjectProtocol {
    @objc optional func projectSelectTabbarViewPreview(currentTab: ProjectSelectTabbarView)
    @objc optional func projectSelectTabbarViewComplete(currentTab: ProjectSelectTabbarView)
}
enum BGShowType{
    case gray  // 深夜模式 预览和完成的默认颜色
    case white // 图片选中后 预览和完成的颜色
}
class TabbarView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT-TABBAR_HEIGHT, width: SCREEN_WIDHT, height: TABBAR_HEIGHT)
        self.backgroundColor = UIColor.init(hexString: "#222222")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class ProjectSelectTabbarView: TabbarView{
    weak var delegate: ProjectSelectTabbarViewDelegate?
    // 预览
    lazy var previewBtn: UIButton = {
        let previewBtn = UIButton()
        previewBtn.setTitle("预览", for: .normal)
        previewBtn.setTitleColor(UIColor.init(hexString: TPREVIEWFONT), for: .normal)
        previewBtn.titleLabel?.font = TSFont17
        return previewBtn
    }()
    // 完成
    lazy var completeBtn: UIButton = {
        let completeBtn = UIButton()
        completeBtn.setTitle("完成", for: .normal)
        completeBtn.setTitleColor(UIColor.init(hexString: TPREVIEWFONT), for: .normal)
        completeBtn.backgroundColor = UIColor.init(hexString: "#2D2D2D")
        completeBtn.titleLabel?.font = TSFont17
        completeBtn.layer.cornerRadius = 4
        return completeBtn
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubViews(){
        self.addSubview(self.previewBtn)
        self.previewBtn.addTarget(self, action: #selector(previewBtnClick), for: .touchUpInside)
        // 预览
        self.previewBtn.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(10)
        }
        // 完成
        self.addSubview(self.completeBtn)
        self.completeBtn.addTarget(self, action: #selector(completeBtnClick), for: .touchUpInside)
        
        self.completeBtn.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.top.equalTo(8)
            make.size.equalTo(CGSize.init(width: 55, height: 32))
        }
    }
    // 选中照片后tabbar上按钮变化设置
    func changeStatus(showType:BGShowType, count: Int){
        if showType == .white{
            self.previewBtn.setTitleColor(.white, for: .normal)
            self.previewBtn.isEnabled = true
            self.completeBtn.setTitleColor(.white, for: .normal)
            self.completeBtn.isEnabled = true
            self.completeBtn.backgroundColor = UIColor.init(hexString: TComplete)
            self.completeBtn.setTitle("完成(\(count))", for: .normal)
            self.completeBtn.snp.updateConstraints { make in
                make.size.equalTo(CGSize.init(width: 80, height: 32))
            }
        }
        if showType == .gray{
            self.previewBtn.setTitleColor(UIColor.init(hexString: TPREVIEWFONT), for: .normal)
            self.previewBtn.isEnabled = false
            self.completeBtn.setTitleColor(UIColor.init(hexString: TPREVIEWFONT), for: .normal)
            self.completeBtn.isEnabled = false
            self.completeBtn.setTitle("完成", for: .normal)
            self.completeBtn.backgroundColor = UIColor.init(hexString: "#2D2D2D")
            self.completeBtn.snp.updateConstraints { make in
                make.size.equalTo(CGSize.init(width: 55, height: 32))
           }
        }
    }
    
    @objc func previewBtnClick(){
        self.delegate?.projectSelectTabbarViewPreview?(currentTab: self)
    }
    
    @objc func completeBtnClick(){
        Global.currentViewController()?.dismiss(animated: true, completion: nil)
        self.delegate?.projectSelectTabbarViewComplete?(currentTab: self)
    }
}

class PreviewTabbarView:TabbarView{
    
    // 编辑
    lazy var editBtn:UIButton = {
        let editBtn = UIButton()
        editBtn.setTitle("编辑", for: .normal)
        editBtn.setTitleColor(UIColor.white, for: .normal)
        editBtn.backgroundColor = UIColor.clear
        editBtn.titleLabel?.font = TSFont17
        return editBtn
    }()
    // 完成
    lazy var completeBtn: UIButton = {
        let completeBtn = UIButton()
        completeBtn.setTitle("完成", for: .normal)
        completeBtn.setTitleColor(UIColor.init(hexString: TPREVIEWFONT), for: .normal)
        completeBtn.backgroundColor = UIColor.init(hexString: "#2D2D2D")
        completeBtn.titleLabel?.font = TSFont17
        completeBtn.layer.cornerRadius = 4
        return completeBtn
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubViews(){
      
        // 编辑
        self.addSubview(self.editBtn)
        self.editBtn.addTarget(self, action: #selector(editBtnClick), for: .touchUpInside)
        
        self.editBtn.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(10)
        }
        // 完成
        self.completeBtn.setTitleColor(.white, for: .normal)
        self.completeBtn.backgroundColor = UIColor.init(hexString: TComplete)
        self.addSubview(self.completeBtn)
        self.completeBtn.addTarget(self, action: #selector(preViewCompleteBtnClick), for: .touchUpInside)
        
        self.completeBtn.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.top.equalTo(8)
            make.size.equalTo(CGSize.init(width: 55, height: 32))
        }
    }
    
    // 选中照片后tabbar上按钮变化设置
    func previewTabbarChangeStatus(showType:BGShowType, count: Int){
        if showType == .white{
            self.completeBtn.setTitleColor(.white, for: .normal)
            self.completeBtn.backgroundColor = UIColor.init(hexString: TComplete)
            self.completeBtn.setTitle("完成(\(count))", for: .normal)
            self.completeBtn.snp.updateConstraints { make in
                make.size.equalTo(CGSize.init(width: 80, height: 32))
            }
        }
        if showType == .gray{
           self.completeBtn.setTitleColor(UIColor.init(hexString: TPREVIEWFONT), for: .normal)
           self.completeBtn.setTitle("完成", for: .normal)
           self.completeBtn.backgroundColor = UIColor.init(hexString: "#2D2D2D")
           self.completeBtn.snp.updateConstraints { make in
                make.size.equalTo(CGSize.init(width: 55, height: 32))
           }
        }
    }
    
    //编辑
    @objc func editBtnClick(){
        print("编辑")
    }
    // 完成
    @objc func preViewCompleteBtnClick(){
        print("完成")
    }
}
