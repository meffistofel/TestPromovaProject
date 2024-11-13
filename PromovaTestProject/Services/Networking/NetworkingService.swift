//
//  NetworkingService.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/11/24.
//

import Foundation
import Dependencies

final class NetworkingService {

    @Dependency(\.urlSession) private var urlSession: URLSession
    @Dependency(\.networkMonitoringService) private var networkMonitoring: NetworkMonitoringService

    func call<T: Decodable>(_ resource: Resource) async throws -> T {
        guard networkMonitoring.isNetworkAvailable else {
            throw APIError.noInternetConnection
        }

        let request = try resource.createRequest()

        let (data, response) = try await urlSession.data(for: request)

        guard let code = (response as? HTTPURLResponse)?.statusCode else {
            throw APIError.unexpectedResponse
        }

        guard HTTPCodes.success.contains(code) else {
            throw APIError.httpCode(code)
        }

        let model = try JSONDecoder().decode(T.self, from: data)

        return model
    }
}
