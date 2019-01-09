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
    var isLoadingOAuthToken = false
    static let shared = GitHubAPIManager()
    var OAuthToken: String?
    
    
    let clientID: String = "cb5da949cdab500dc187"
    let clientSecret: String = "02619da18f781c7ab445b2777e2bedccc2ef6d15"
    
    func hasOAuthToken() -> Bool {
        if let token = self.OAuthToken {
            return !token.isEmpty
        }
        return false
    }
    
    // MARK: - OAuth flow
    func URLToStartOAuth2Login() -> URL? {
        let authPath: String = "https://github.com/login/oauth/authorize" +
        "?client_id=\(clientID)&scope=gist&state=TEST_STATE"
        return URL(string: authPath)
    }
    
    // MARK: - Auth 2.0
    func printMyStarredGistsWithAuth2() {
        Alamofire.request(GistRouter.getMyStarred()).responseString { (response) in
            guard let receivedString = response.result.value else {
                print(response.result.error!)
                return
            }
            print(receivedString)
        }
    }
    
    func clearCache() {
        let cache = URLCache.shared
        cache.removeAllCachedResponses()
    }
    
    func printPublicGists() {
        Alamofire.request(GistRouter.getPublic()).responseString { (response) in
            if let receivedString = response.result.value {
                print(receivedString)
            }
        }
    }
    
    func fetchPublicGists(pageToLoad: String?, completionHandler: @escaping (Result<[Gist]>, String?) -> Void) {
        if let urlString = pageToLoad {
            self.fetchGists(GistRouter.getAtPath(urlString), completionHandler: completionHandler)
        } else {
            self.fetchGists(GistRouter.getPublic(), completionHandler: completionHandler)
        }
    }
    
    func fetchGists(_ urlRequest: URLRequestConvertible,
                    completionHandler: @escaping (Result<[Gist]>, String?) -> Void) {
        Alamofire.request(urlRequest).responseData { (response) in
            let decoder = JSONDecoder()
            let result: Result<[Gist]> = decoder.decodeResponse(from: response)
            let next = self.parseNextPageFromHeaders(response: response.response)
            completionHandler(result, next)
        }
    }
    
    func imageFrom(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        Alamofire.request(url).responseData { (response) in
            guard let data = response.data else {
                completionHandler(nil, response.error)
                return
            }
            
            let image = UIImage(data: data)
            completionHandler(image, nil)
        }
    }
    
    private func parseNextPageFromHeaders(response: HTTPURLResponse?) -> String? {
        guard let linkHeader = response?.allHeaderFields["Link"] as? String else {
            return nil
        }
        // looks like: <https://...?page=2?; rel="next", <https://...?page=6>; rel="last"
        // so split on ","
        let components = linkHeader.components(separatedBy: ",")
        // now we have separate lines like '<https://...?page=2>; rel="next"'
        for item in components {
            // see if it's "next"
            let rangeOfNext = item.range(of: "rel=\"next\"", options:[])
            guard rangeOfNext != nil else {
                continue
            }
            // this is the "next" item, extract the URL
            let rangeOfPaddedURL = item.range(of: "<.*>;", options: .regularExpression, range: nil, locale: nil)
            guard let range = rangeOfPaddedURL else {
                return nil
            }
            // strip off the < and >;
            let start = item.index(range.lowerBound, offsetBy: 1)
            let end = item.index(range.upperBound, offsetBy: -2)
            let trimmedSubstring = item[start..<end]
            return String(trimmedSubstring)
        }
        return nil
    }
    
    func processOAuthStep1Response(_ url: URL) {
        // extract the code from the URL
        guard let code = extractCodeFromOAuthStep1Response(url) else {
            isLoadingOAuthToken = false
            return
        }
        swapAuthCodeForToken(code: code)
    }
    
    func extractCodeFromOAuthStep1Response(_ url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var code: String?
        guard let queryItems = components?.queryItems else {
            isLoadingOAuthToken = false
            return nil
        }
        for queryItem in queryItems {
            if queryItem.name.lowercased() == "code" {
                code = queryItem.value
                break
            }
        }
        return code
    }
    
    func swapAuthCodeForToken(code: String) {
        let getTokenPath: String = "https://github.com/login/oauth/access_token"
        let tokenParams = ["client_id": clientID,
                           "client_secret": clientSecret,
                           "code": code]
        let jsonHeader = ["Accept": "application/json"]
        Alamofire.request(getTokenPath, method: .post, parameters: tokenParams, encoding: URLEncoding.default, headers: jsonHeader).responseJSON { (response) in
            guard response.result.error == nil else {
                print(response.result.error!)
                self.isLoadingOAuthToken = false
                return
            }
            guard let value = response.result.value else {
                self.isLoadingOAuthToken = false
                print("no string received in response when swapping oauth code for token")
                return
            }
            guard let jsonResult = value as? [String: String] else {
                print("no data received or data not json")
                self.isLoadingOAuthToken = false
                return
            }
            
            self.OAuthToken = self.parseOAuthTokenResponse(jsonResult)
            self.isLoadingOAuthToken = false
            guard self.hasOAuthToken() else {
                return
            }
            // TEST: use token to fetch starred gists
            self.printMyStarredGistsWithAuth2()
        }
    }
    
    func parseOAuthTokenResponse(_ json: [String: String]) -> String? {
        var token: String?
        for (key, value) in json {
            switch key {
            case "access_token":
                token = value
            case "scope":
                // TODO: verify scope
                print("SET_SCOPE")
            case "token_type":
                // TODO: verify is bearer
                print("CHECK IF BEARER")
            default:
                print("got more than I expected from the OAuth token exchange")
                print(key)
            }
        }
        return token
    }
}
