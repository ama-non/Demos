//
//  AnchorGroup.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/11/29.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

@objcMembers
class AnchorGroup: NSObject {
    // 该组中对应的房间信息
    var room_list: [[String : NSObject]]? {
        didSet {
            guard let room_list = room_list else { return }
            for dict in room_list {
                anchors.append(AnchorModel(dict: dict))
            }
        }
    }
    // 组显示标题
    var tag_name: String = ""
    // 组显示图标
    var icon_name: String = "home_header_normal"
    // 游戏对应的图标
    var icon_url: String = ""
    // 定义主播的模型对象数组
    lazy var anchors: [AnchorModel] = [AnchorModel]()
    
    // MARK:- 构造函数
    override init() {}
    
    init(dict: [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
