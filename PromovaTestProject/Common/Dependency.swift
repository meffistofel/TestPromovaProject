//
//  Dependency.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import ComposableArchitecture
import Foundation

private enum NetworkServiceKey: DependencyKey {
    static let liveValue: NetworkServiceProtocol = NetworkingService()
}

private enum NetworkMonitoringServiceKey: DependencyKey {
    static let liveValue: NetworkMonitoringService = NetworkMonitoringService()
}

private enum AnimalAPIServiceKey: DependencyKey {
    static let liveValue: AnimalAPIServiceProtocol = AnimalAPIService()
}

private enum AnimalCachedServiceKey: DependencyKey {
    static let liveValue: AnimalCachedServiceProtocol = AnimalCachedService()
}

private enum CoreDataServiceKey: DependencyKey {
    static let liveValue: CoreDataServiceProtocol = CoreDataService()
}

private enum URLSessionKey: DependencyKey {
    static let liveValue: URLSession = URLSession.defaultAppSession
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
    
    var animalAPIService: AnimalAPIServiceProtocol {
        get { self[AnimalAPIServiceKey.self] }
        set { self[AnimalAPIServiceKey.self] = newValue }
    }

    var coreDataService: CoreDataServiceProtocol {
        get { self[CoreDataServiceKey.self] }
        set { self[CoreDataServiceKey.self] = newValue }
    }

    var animalCachedService: AnimalCachedServiceProtocol {
        get { self[AnimalCachedServiceKey.self] }
        set { self[AnimalCachedServiceKey.self] = newValue }
    }

    var urlSession: URLSession {
        get { self[URLSessionKey.self] }
        set { self[URLSessionKey.self] = newValue }
    }
}

