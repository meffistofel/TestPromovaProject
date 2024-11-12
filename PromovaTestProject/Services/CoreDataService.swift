//
//  CoreDataService.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import Foundation
import CoreData
import OSLog

protocol CoreDataServiceProtocol {
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]?
    func saveChanges()
}

private let logger = Logger(subsystem: "CoreDataService", category: "CoreDataService")
private let modelFileName: String = "PromovaTestProject"

final class CoreDataService: NSPersistentContainer, CoreDataServiceProtocol, @unchecked Sendable {

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

    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]? {
        do {
            return try viewContext.fetch(request)
        } catch {
            logger.error("\(error)")
            return nil
        }
    }


    func saveChanges() {
        guard viewContext.hasChanges else {
            return
        }

        do {
            try viewContext.save()
        } catch {
            logger.error("\(error)")
        }
    }
}

// MARK: - Preview
extension CoreDataService {

    static var preview: CoreDataService = {
        let controller = CoreDataService(inMemory: true)

        return controller
    }()
}

