//
//  CollectionBaseCell.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/12/1.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

class CollectionBaseCell: UICollectionViewCell {
    // MARK:- 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var onlineBtn: UIButton!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    // MARK:- 定义模型
    var anchor: AnchorModel? {
        didSet {
            // 校验模型是否有值
            guard let anchor = anchor else { return }
            
            // 取出在线人数显示的文字
            var onlineStr: String = ""
            if anchor.online >= 100000 {
                onlineStr = "\(Int(anchor.online / 100000))万在线"
            } else {
                onlineStr = "\(anchor.online)在线"
            }
            onlineBtn.setTitle(onlineStr, for: .normal)
            
            // 昵称的显示
            nicknameLabel.text = anchor.nickname
            
            // 显示封面图片
            guard let iconURL = URL(string: anchor.vertical_src) else { return }
            iconImageView.kf.setImage(with: iconURL)
        }
    }
}
