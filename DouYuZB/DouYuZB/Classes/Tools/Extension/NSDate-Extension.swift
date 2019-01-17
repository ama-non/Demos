//
//  NSDate-Extension.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/11/29.
//  Copyright © 2018年 Atom. All rights reserved.
//

import Foundation

extension Date {
    static func getCurrentTime() -> String {
        let nowDate = Date()
        
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
    }
}
