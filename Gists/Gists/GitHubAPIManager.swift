//
//  GitHubAPIManager.swift
//  Gists
//
//  Created by 徐亦农 on 2019/1/4.
//  Copyright © 2019年 Atom. All rights reserved.
//

import Foundation
import Alamofire

class GitHubAPIManager {
    static let shared = GitHubAPIManager()
    
    func printPublicGists() {
        // TODO: implement
        Alamofire.request(GistRouter.getPublic()).responseString { (response) in
            if let receivedString = response.result.value {
                print(receivedString)
            }
        }
    }
    
    func fetchPublicGists(completionHandler: @escaping (Result<[Gist]>) -> Void) {
        Alamofire.request(GistRouter.getPublic()).responseData { (response) in
            let decoder = JSONDecoder()
            let result: Result<[Gist]> = decoder.decodeResponse(from: response)
            completionHandler(result)
        }
    }
}
