//
//  AnimalHomeEnvironment.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import Dependencies

struct AnimalHomeEnvironment {
    @Dependency(\.animalAPIService) var animalAPIService
}
