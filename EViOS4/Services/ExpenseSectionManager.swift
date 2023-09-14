//
//  ExpenseSectionManager.swift
//  EViOS4
//
//  Created by Student07 on 14/09/2023.
//

import Foundation
import CoreData

extension DataManager {
    
    // MARK: - ExpenseSection
    
    func requestExpenseSection() -> NSFetchRequest<ExpenseSection> {
        let request = ExpenseSection.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        return request
    }
    
    func getExpenseSectionResultsController() -> NSFetchedResultsController<ExpenseSection> {
        return NSFetchedResultsController(
            fetchRequest: requestExpenseSection(),
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
    }
    
    func getExpenseSections() -> [ExpenseSection]? {
        let request = requestExpenseSection()
        return fetch(request)
    }
    
    func addExpenseSection(name: String) {
        let expenseSection = ExpenseSection(context: context)
        expenseSection.name = name
        saveContext()
    }

    func deleteExpenseSection(_ expenseSection: ExpenseSection) {
        if let expenses = expenseSection.expense {
            for expense in expenses {
                deleteExpense(expense)
            }
        }
        context.delete(expenseSection)
        saveContext()
    }
}
