//
//  AlertView.swift
//  TTImagePicker
//
//  Created by TYQ on 2021/11/17.
//

import UIKit

class AlertView: UIView {
    @IBOutlet weak var safeVeiw: UIView!
    @IBOutlet weak var safeHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    class func loadFromNib()->AlertView{
        return Bundle.main.loadNibNamed("AlertView", owner: nil, options: nil)?.first as!AlertView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        print(STATUSBAR_HEIGHT)
        if(STATUSBAR_HEIGHT == 20){
            safeVeiw.isHidden = true
            safeHeight.constant = 0
            viewHeight.constant = 235 - 34
        }else{
            safeVeiw.isHidden = false
            safeHeight.constant = 34
            viewHeight.constant = 235
        }
        self.frame = UIScreen.main.bounds
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        print("拍摄")
    }
    @IBAction func selectPhoto(_ sender: UIButton) {
        print("选择照片")
        self.removeFromSuperview()
        let album = AlbumViewController()
        let currentVC = Global.currentViewController()
        album.modalPresentationStyle = .fullScreen
        currentVC?.present(album, animated: true, completion: nil)
    }
    @IBAction func makeVideo(_ sender: UIButton) {
        print("制作视频")
    }
    @IBAction func cancel(_ sender: UIButton) {
        print("取消")
        self.removeFromSuperview()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
}
