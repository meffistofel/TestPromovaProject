//
//  CoreDataService.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import Foundation
import CoreData
import OSLog

private let logger = Logger(subsystem: "PromovaTestProject", category: "CoreDataService")
private let modelFileName: String = "Promova"

final class CoreDataService: NSPersistentContainer, @unchecked Sendable {

    static let shared: CoreDataService = CoreDataService()

    lazy var backgroundObjectContext: NSManagedObjectContext = {
        let context = newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump

        return context
    }()

    init(name: String = modelFileName, inMemory: Bool = false) {
        guard let model: NSManagedObjectModel = NSManagedObjectModel.mergedModel(from: nil) else {
            fatalError("Can't load managed object models from bundle")
        }
        super.init(name: name, managedObjectModel: model)

        if inMemory {
            persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        loadPersistentStores(completionHandler: { (_, error) in
            if let error: NSError = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension CoreDataService {

    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) throws -> [T]? {
         try viewContext.fetch(request)
    }

    func fetchInBackground<T: NSManagedObject>(request: NSFetchRequest<T>) throws -> [T]? {
        try backgroundObjectContext.fetch(request)
    }

    func numberOfElements<T: NSManagedObject>(for fetchRequest: NSFetchRequest<T>) throws -> Int {
        try backgroundObjectContext.count(for: fetchRequest)
    }

    func saveChanges() throws {
        guard viewContext.hasChanges else {
            return
        }

        try viewContext.save()
    }

    func saveBGChanges() throws {
        guard backgroundObjectContext.hasChanges else {
            return
        }

        try backgroundObjectContext.save()
    }
}
