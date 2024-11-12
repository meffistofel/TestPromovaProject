//
//  URLSession+extensions.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/11/24.
//

import Foundation

extension URLSession {

    static var defaultAppSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true

        return URLSession(configuration: configuration)
    }()
}
