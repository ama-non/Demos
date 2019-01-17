//
//  NetworkTools.swift
//  DouYuZB
//
//  Created by 徐亦农 on 2018/11/28.
//  Copyright © 2018年 Atom. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case GET
    case POST
}

class NetworkTools {
    class func  requestData(type: MethodType, URLString: String, parameters: [String : Any]? = nil, finishedCallback: @escaping (_ result : Any) -> ()) {
        // 获取类型
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        
        // 发送网络请求
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            //  获取结果
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            
            // 将结果回调出去
            finishedCallback(result)
        }
    }
}
