//
//  NSFetchRequest+Animal.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import CoreData

extension NSFetchRequest where ResultType == AnimalMO {
    static func animals() -> NSFetchRequest<AnimalMO> {
        let request: NSFetchRequest<AnimalMO> = AnimalMO.fetchRequest()

        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(AnimalMO.order), ascending: true)]

        return request
    }
}
