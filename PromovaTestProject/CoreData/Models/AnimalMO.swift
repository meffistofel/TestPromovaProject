//
//  AnimalMO.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import CoreData

@objc(AnimalMO)
public class AnimalMO: NSManagedObject {

    var statusOrEmpty: String {
        status ?? ""
    }

    var statusEnum: Animal.Status {
        get { .init(rawValue: statusOrEmpty) ?? .free }
        set { status = newValue.rawValue }
    }

    var contentArray: [AnimalContentMO]? {
        let contentsArray = contents?.allObjects as? [AnimalContentMO]
        return contentsArray?.isEmpty == false ? contentsArray : nil
    }
}

extension AnimalMO {
    convenience init(context: NSManagedObjectContext, animal: Animal) {
        self.init(context: context)

        uuid = animal.id
        title = animal.title
        descriptionTitle = animal.description
        image = animal.image
        order = Int16(animal.order)
        statusEnum = animal.status

        if let contents = animal.content?.map({ AnimalContentMO(context: context, content: $0) }) {
            let contentSet = NSSet(array: contents)
            addToContents(contentSet)
        }
    }
}
