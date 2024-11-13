//
//  AnimalCachedService.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import Dependencies
import IdentifiedCollections

struct AnimalCachedServiceInterface {
    var fetchAnimals: () async throws -> (IdentifiedArrayOf<Animal>, Error?)
}

final class AnimalCachedService {
    @Dependency(\.animalAPIService) private var animalAPIService
    @Dependency(\.coreDataService) private var coreDataService

    func fetchAnimals() async throws  -> (IdentifiedArrayOf<Animal>, Error?) {
        do {
            let animals = try await animalAPIService.fetchAnimals()
            let _ = animals.map { AnimalMO(context: coreDataService.backgroundObjectContext, animal: $0) }

            try coreDataService.saveBGChanges()

            let sortedAnimals = animals.sorted(by: { $0.order < $1.order })
            let identifiedAnimals = IdentifiedArrayOf(uniqueElements: sortedAnimals)

            return (identifiedAnimals, nil)
        } catch  {
            return try await coreDataService.backgroundObjectContext.perform { [weak self] in
                let animalsMO = try self?.coreDataService.fetchInBackground(request: .animals()) ?? []
                let animals = animalsMO.map(Animal.init)
                let identifiedAnimals = IdentifiedArrayOf(uniqueElements: animals)

                return (identifiedAnimals, error)
            }
        }
    }
}
