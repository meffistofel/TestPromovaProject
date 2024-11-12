//
//  AnimalAPIService.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import ComposableArchitecture

protocol AnimalAPIServiceProtocol {
    func fetchAnimal() async throws -> IdentifiedArrayOf<Animal>
}

final class AnimalAPIService: AnimalAPIServiceProtocol {

    @Dependency(\.networkService) private var networkService

    func fetchAnimal() async throws -> IdentifiedArrayOf<Animal> {
        try await networkService.call(.init(route: "/main/animals.json"))
    }
}
