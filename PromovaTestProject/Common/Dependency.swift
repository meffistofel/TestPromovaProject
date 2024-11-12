//
//  Dependency.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import ComposableArchitecture

private enum NetworkServiceKey: DependencyKey {
    static let liveValue: NetworkServiceProtocol = NetworkingService()
}

private enum NetworkMonitoringServiceKey: DependencyKey {
    static let liveValue: NetworkMonitoringService = NetworkMonitoringService()
}

extension DependencyValues {
    var networkMonitoringService: NetworkMonitoringService {
        get { self[NetworkMonitoringServiceKey.self] }
        set { self[NetworkMonitoringServiceKey.self] = newValue }
    }

    var networkService: NetworkServiceProtocol {
        get { self[NetworkServiceKey.self] }
        set { self[NetworkServiceKey.self] = newValue }
    }
}

