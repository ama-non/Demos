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
    let createdAt: Date
    let updatedAt: Date
    let files: [String: File] // JSON does filename: { file data }
    lazy var orderedFiles: [(name: String, details: File)] = {
        var orderedFiles: [(name: String, details: File)] = []
        for (key, value) in files {
            let item = (name: key, details: value)
            orderedFiles.append(item)
        }
        return orderedFiles
    }()
    
    enum CodingKeys: String, CodingKey {
        case id
        case gistDescription = "description"
        case url
        case owner
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case files
    }
}
