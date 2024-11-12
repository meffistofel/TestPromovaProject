//
//  AnimalContentMO.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import CoreData

@objc(AnimalContentMO)
public class AnimalContentMO: NSManagedObject {

}

extension AnimalContentMO {
    convenience init(context: NSManagedObjectContext, content: AnimalContent) {
        self.init(context: context)

        fact = content.fact
        image = content.image
    }
}
