//
//  Dependency.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import ComposableArchitecture
import Foundation

// MARK: General

private enum NetworkServiceKey: DependencyKey {
    static let liveValue: NetworkingService = NetworkingService()
}

private enum NetworkMonitoringServiceKey: DependencyKey {
    static let liveValue: NetworkMonitoringService = NetworkMonitoringService()
}

private enum URLSessionKey: DependencyKey {
    static let liveValue: URLSession = URLSession.defaultAppSession
}

private enum CoreDataServiceKey: DependencyKey {
    static let liveValue: CoreDataService = CoreDataService()
}


// MARK: Interface

private enum AnimalAPIServiceKey: DependencyKey {
    static var liveValue: AnimalAPIServiceInterface {
        let animalAPIService = AnimalAPIService()

        return AnimalAPIServiceInterface(fetchAnimals: animalAPIService.fetchAnimals)
    }
}

private enum AnimalCachedServiceKey: DependencyKey {
    static var liveValue: AnimalCachedServiceInterface {
        let animalCacheService = AnimalCachedService()

        return AnimalCachedServiceInterface(fetchAnimals: animalCacheService.fetchAnimals)
    }
}

// MARK: DependencyValues

extension DependencyValues {
    var animalAPIService: AnimalAPIServiceInterface {
        get { self[AnimalAPIServiceKey.self] }
        set { self[AnimalAPIServiceKey.self] = newValue }
    }

    var animalCachedService: AnimalCachedServiceInterface {
        get { self[AnimalCachedServiceKey.self] }
        set { self[AnimalCachedServiceKey.self] = newValue }
    }

    var coreDataService: CoreDataService {
        get { self[CoreDataServiceKey.self] }
        set { self[CoreDataServiceKey.self] = newValue }
    }

    var networkMonitoringService: NetworkMonitoringService {
        get { self[NetworkMonitoringServiceKey.self] }
        set { self[NetworkMonitoringServiceKey.self] = newValue }
    }

    var networkService: NetworkingService {
        get { self[NetworkServiceKey.self] }
        set { self[NetworkServiceKey.self] = newValue }
    }


    var urlSession: URLSession {
        get { self[URLSessionKey.self] }
        set { self[URLSessionKey.self] = newValue }
    }
}

