//
//  URLSession+Extension.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/13/24.
//

import Foundation

extension URLSession {
    static var defaultAppSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5 // setup for test in project
        configuration.timeoutIntervalForResource = 5 // setup for test in project
        configuration.waitsForConnectivity = true

        return URLSession(configuration: configuration)
    }()
}
