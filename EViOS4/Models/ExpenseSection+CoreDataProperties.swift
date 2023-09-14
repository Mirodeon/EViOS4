//
//  ExpenseSection+CoreDataProperties.swift
//  EViOS4
//
//  Created by Student07 on 14/09/2023.
//
//

import Foundation
import CoreData


extension ExpenseSection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseSection> {
        return NSFetchRequest<ExpenseSection>(entityName: "ExpenseSection")
    }

    @NSManaged public var name: String
    @NSManaged public var expense: Set<Expense>?

}

// MARK: Generated accessors for expense
extension ExpenseSection {

    @objc(addExpenseObject:)
    @NSManaged public func addToExpense(_ value: Expense)

    @objc(removeExpenseObject:)
    @NSManaged public func removeFromExpense(_ value: Expense)

    @objc(addExpense:)
    @NSManaged public func addToExpense(_ values: Set<Expense>)

    @objc(removeExpense:)
    @NSManaged public func removeFromExpense(_ values: Set<Expense>)

}

extension ExpenseSection : Identifiable {

}
