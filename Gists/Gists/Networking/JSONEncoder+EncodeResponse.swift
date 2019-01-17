//
//  JSONEncoder+EncodeResponse.swift
//  Gists
//
//  Created by 徐亦农 on 2019/1/4.
//  Copyright © 2019年 Atom. All rights reserved.
//

import Foundation
import Alamofire

extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T> {
        guard response.error == nil else {
            // got an error in getting the data, need to handle it
            print(response.error!)
            return .failure(BackendError.network(error: response.error!))
        }
        
        // make sure we got JSON and it's a dictionary
        guard let responseData = response.data else {
            print("didnlt get any data from API")
            return .failure(BackendError.unexpectedResponse(reason: "Did not get data in response"))
        }
        
        // check for "message" errors in the JSON because this API does that
        if let apiProvidedError = try? self.decode(APIProvidedError.self, from: responseData) {
            return .failure(BackendError.apiProvidedError(reason: apiProvidedError.message))
        }
        
        // turn data into expected type
        do {
            let item = try self.decode(T.self, from: responseData)
            return .success(item)
        } catch {
            print("error trying ro decode response")
            print(error)
            return .failure(BackendError.parsing(reason: error))
        }
    }
}
