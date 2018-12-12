//
//  AnchorModel.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/11/29.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

@objcMembers
class AnchorModel: NSObject {
    // 房间ID
    var room_id: Int = 0
    // 房间图片对应的URLString
    var vertical_src: String = ""
    // 判断是手机直播还是电脑直播
    // 0是电脑直播，1是手机直播
    var isVertical: Int = 0
    // 房间名称
    var room_name: String = ""
    // 主播昵称
    var nickname: String = ""
    // 观看人数
    var online: Int = 0
    // 所在城市
    var anchor_city: String = ""
    
    init(dict: [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
