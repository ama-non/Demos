//
//  BaseGameModel.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/12/12.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit

@objcMembers
class BaseGameModel: NSObject {
    // MARK:- 定义属性
    var tag_name: String = ""
    var icon_url: String = ""
    
    // MARK:- 构造函数
    override init() {}
    
    // MARK:- 自定义构造函数
    init(dict: [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
