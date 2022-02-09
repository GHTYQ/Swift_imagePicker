//
//  ToastView.swift
//  TTImagePicker
//
//  Created by TYQ on 2021/11/30.
//

import UIKit

class ToastView: UIView {
   
    lazy var toastView: UIView = {
        
        let toast = UIView()
        toast.backgroundColor = UIColor.init(hexString: TBG)
        toast.layer.cornerRadius = 10
        self.addSubview(toast)

        toast.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize.init(width: SCREEN_WIDHT-100, height: 160))
        }

        let msgLab = UILabel()
        msgLab.text = "你最多只能选择9张照片"
        msgLab.textColor = .white
        toast.addSubview(msgLab)

        msgLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(45)
        }

        let line = UIView()
        line.backgroundColor = UIColor.init(hexString: TLINE)
        toast.addSubview(line)

        line.snp.makeConstraints { make in
            make.bottom.equalTo(-60)
            make.left.width.equalToSuperview()
            make.height.equalTo(1)
        }

        let sure = UIButton()
        sure.setTitle("我知道了", for: .normal)
        sure.setTitleColor(UIColor.init(hexString: TSURE), for: .normal)
        sure.addTarget(self, action: #selector(sureClick), for: .touchUpInside)
        toast.addSubview(sure)

        sure.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-15)
        }
        return toast
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        self.backgroundColor =  UIColor.init(hexString: TBLACK, alpha: 0.5)
        self.addSubview(self.toastView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func showToast(){
        Global.currentWindow().addSubview(ToastView())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
    
    @objc func sureClick(){
        self.removeFromSuperview()
    }

}
