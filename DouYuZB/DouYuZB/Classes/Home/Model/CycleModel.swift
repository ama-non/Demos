//
//  CycleModel.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/12/10.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

@objcMembers
class CycleModel: NSObject {
    // 标题
    var title: String = ""
    // 展示的图片地址
    var pic_url: String = ""
    // 主播信息对应的字典
    var room: [String : NSObject]? {
        didSet {
            guard let room = room else {
                return
            }
            anchor = AnchorModel(dict: room)
        }
    }
    // 主播信息对应的模型
    var anchor: AnchorModel?
    
    // MARK:- 自定义构造函数
    init(dict: [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
