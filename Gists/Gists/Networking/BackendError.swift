//
//  BackendError.swift
//  Gists
//
//  Created by 徐亦农 on 2019/1/7.
//  Copyright © 2019年 Atom. All rights reserved.
//

import Foundation

enum BackendError: Error {
    case network(error: Error)
    case unexpectedResponse(reason: String)
    case parsing(reason: Error)
    case apiProvidedError(reason: String)
    case authCouldNot(reason: String)
    case autuLost(reason: String)
    case missingRequiredInput(reason: String)
}

struct APIProvidedError: Codable {
    let message: String
}
