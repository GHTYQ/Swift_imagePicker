//
//  AlbumProjectSelectTableViewCell.swift
//  TTImagePicker
//
//  Created by TYQ on 2022/1/6.
//

import UIKit

class AlbumProjectSelectTableViewCell: UITableViewCell {
    // 缩略图
    @IBOutlet weak var thumbnail: UIImageView!
    // 类别
    @IBOutlet weak var typeLab: UILabel!
    // 数量
    @IBOutlet weak var numLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = TNav_Color
    }
    
}
