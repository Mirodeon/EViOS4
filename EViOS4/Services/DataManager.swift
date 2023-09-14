//
//  DataManager.swift
//  EViOS4
//
//  Created by Student07 on 14/09/2023.
//

import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    let context: NSManagedObjectContext
    
    init() {
        self.context = DataManager.getContext()
    }
    
    private static func getContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "EViOS4")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        initData(context: container.viewContext)

        return container.viewContext
    }
    
    private static func initData(context: NSManagedObjectContext) {
        var currentSections: [ExpenseSection] = []
        
        do {
            currentSections = try context.fetch(ExpenseSection.fetchRequest())
        } catch {
            print("Could not fetch.", error)
        }
        
        if (currentSections.isEmpty) {
            ["Tax", "Food", "House", "Hobby", "Need"].forEach { name in
                let newSection = ExpenseSection(context: context)
                newSection.name = name
                
                do {
                    try context.save()
                } catch {
                    context.rollback()
                    print("Error saving context", error)
                }
            }
        }
    }

    func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            context.rollback()
            print("Error saving context", error)
        }
    }
    
    func fetch<T>(_ request: NSFetchRequest<T>) -> [T]? {
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            print("Could not fetch.", error)
            return nil
        }
    }
    
    func performFetch<T>(_ resultsController: NSFetchedResultsController<T>) {
        do {
            try resultsController.performFetch()
        } catch {
            print("Error fetching initial data", error)
        }
    }
}
