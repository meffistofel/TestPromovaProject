//
//  HTTp.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/11/24.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}

enum HTTPHeadersValue: String {
    case applicationJson = "application/json"
    case applicationURLEncoded = "application/x-www-form-urlencoded"
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<Int>
typealias HTTPHeaders = [String: String]
typealias HTTParameters = [String: Any]

extension HTTPCodes {
    static let success = 200 ..< 300
}

enum MediaType {
    case video
    case image
}
