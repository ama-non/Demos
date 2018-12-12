//
//  CollectionBeautyCell.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/11/28.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionBeautyCell: CollectionBaseCell {
    
    // MARK:- 定义控件属性
    @IBOutlet weak var cityBtn: UIButton!
    
    // MARK:- 定义属性
    override var anchor: AnchorModel? {
        didSet {
            // 将属性传递给父类
            super.anchor = anchor
            
            // 显示所在城市
            cityBtn.setTitle(anchor?.anchor_city, for: .normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
