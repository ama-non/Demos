//
//  File.swift
//  Gists
//
//  Created by 徐亦农 on 2019/1/11.
//  Copyright © 2019年 Atom. All rights reserved.
//

import Foundation

struct File: Codable {
    enum CodingKeys: String, CodingKey {
        case url = "raw_url"
        case content
    }
    
    let url: URL
    let content: String?
}
