//
//  Gist.swift
//  Gists
//
//  Created by 徐亦农 on 2019/1/4.
//  Copyright © 2019年 Atom. All rights reserved.
//

import Foundation

struct Gist: Codable {
    struct Owner: Codable {
        var login: String
        var avatarURL: URL?
        
        enum CodingKeys: String, CodingKey {
            case login
            case avatarURL = "avatar_url"
        }
    }
    
    var id: String
    var gistDescription: String?
    var url: URL?
    var owner: Gist.Owner?
    
    enum CodingKeys: String, CodingKey {
        case id
        case gistDescription = "description"
        case url
        case owner
    }
}
