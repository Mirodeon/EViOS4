//
//  ExpenseManager.swift
//  EViOS4
//
//  Created by Student07 on 14/09/2023.
//

import Foundation
import CoreData

extension DataManager {
    
    // MARK: - Expense
    
    func requestExpense() -> NSFetchRequest<Expense> {
        let request = Expense.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "expenseSection.name", ascending: true),
            NSSortDescriptor(key: "name", ascending: true),
            NSSortDescriptor(key: "date", ascending: true),
            NSSortDescriptor(key: "value", ascending: true)
        ]
        return request
    }
    
    func getExpenseResultsController() -> NSFetchedResultsController<Expense> {
        return NSFetchedResultsController(
            fetchRequest: requestExpense(),
            managedObjectContext: context,
            sectionNameKeyPath: "expenseSection.name",
            cacheName: nil)
    }
    
    func getExpenses() -> [Expense]? {
        let request = requestExpense()
        return fetch(request)
    }
    
    func addExpense(name: String, value: Float, date: Date, section: ExpenseSection) {
        let expense = Expense(context: context)
        expense.name = name
        expense.value = value
        expense.date = date
        expense.expenseSection = section
        saveContext()
    }

    func deleteExpense(_ expense: Expense) {
        context.delete(expense)
        saveContext()
    }
}
