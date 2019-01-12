//
//  GistRouter.swift
//  Gists
//
//  Created by 徐亦农 on 2019/1/4.
//  Copyright © 2019年 Atom. All rights reserved.
//

import Foundation
import Alamofire

enum GistRouter: URLRequestConvertible {
    static let baseURLString = "https://api.github.com"
    
    case getPublic()
    case getMyStarred()
    case getAtPath(String)
    case getMine()
    case isStarred(String)
    case star(String)
    case unstar(String)
    case delete(String)
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getPublic, .getMyStarred, .getAtPath, .getMine, .isStarred:
                return .get
            case .star:
                return .put
            case .unstar, .delete:
                return .delete
            }
        }
        
        let url: URL = {
            let relativePath: String
            switch self {
            case .getAtPath(let path):
            // already have the full URL, so just return it
                return URL(string: path)!
            case .getPublic:
                relativePath = "gists/public"
            case .getMyStarred:
                relativePath = "gists/starred"
            case .getMine:
                relativePath = "gists"
            case . isStarred(let id):
                relativePath = "gists/\(id)/star"
            case .star(let id):
                relativePath = "gists/\(id)/star"
            case .unstar(let id):
                relativePath = "gists/\(id)/star"
            case .delete(let id):
                relativePath = "gists/\(id)"
            }
            
            var url = URL(string: GistRouter.baseURLString)!
            url.appendPathComponent(relativePath)
            return url
        }()
        
        // no params to send with this request so ignore then for now
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        // set OAuth token if we have one
        if let token = GitHubAPIManager.shared.OAuthToken {
            urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
}
