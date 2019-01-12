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
    case create(Data)
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getPublic, .getMyStarred, .getAtPath, .getMine, .isStarred:
                return .get
            case .star:
                return .put
            case .unstar, .delete:
                return .delete
            case .create:
                return .post
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
            case .create:
                relativePath = "gists"
            }
            
            var url = URL(string: GistRouter.baseURLString)!
            url.appendPathComponent(relativePath)
            return url
        }()
        
        let body: Data? = {
            switch self {
            case .create(let jsonAsData):
                return jsonAsData
            default:
                return nil
            }
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        // set OAuth token if we have one
        if let token = GitHubAPIManager.shared.OAuthToken {
            urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        urlRequest.httpBody = body
        
        return urlRequest
    }
}
