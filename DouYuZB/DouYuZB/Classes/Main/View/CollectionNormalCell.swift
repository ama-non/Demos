//
//  CollectionNormalCell.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/11/28.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

class CollectionNormalCell: CollectionBaseCell {
    
    // 定义控件属性
    @IBOutlet weak var roomNameLabel: UILabel!
    
    
    //mark:- 定义模型属性
    override var anchor: AnchorModel? {
        didSet {
            // 将属性传递给父类
            super.anchor = anchor
            
            // 显示房间名称
            roomNameLabel.text = anchor?.room_name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
