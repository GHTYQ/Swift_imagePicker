//
//  ViewController.swift
//  TTImagePicker
//
//  Created by TYQ on 2021/11/17.
//

import UIKit
import Photos
class ViewController: UIViewController {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        print("change")
    }
    
    var pickerVC = UIImagePickerController()
    let width = UIScreen.main.bounds.size.width
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let btn = UIButton.init(frame: CGRect.init(x: (SCREEN_WIDHT-100)/2.0, y: 100, width: 100, height: 100))
        btn.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        btn.setTitle("选择", for: .normal)
        btn.backgroundColor =  UIColor.gray
        self.view.addSubview(btn)
    }
    
    @objc func takePhoto(sender:UIButton){
        let alertV = AlertView.loadFromNib()
        self.view.addSubview(alertV)
    }
}

