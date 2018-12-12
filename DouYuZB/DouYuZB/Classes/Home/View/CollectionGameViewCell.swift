//
//  CollectionGameViewCell.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/12/10.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

class CollectionGameViewCell: UICollectionViewCell {
    
    //MARK:- 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK:- 定义模型属性
    var group: AnchorGroup? {
        didSet {
            titleLabel.text = group?.tag_name
            let iconURL = URL(string: group?.icon_url ?? "")
            iconImageView.kf.setImage(with: iconURL, placeholder: UIImage(named: "home_more_btn"))
        }
    }
    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
