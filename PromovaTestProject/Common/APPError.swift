//
//  APPEror.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import Foundation

enum AppError: Error, Equatable {
    case error(String)
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        ""
    }

    var recoverySuggestion: String? {
        switch self {
        case .error(let text):
            text
        }
    }
}
