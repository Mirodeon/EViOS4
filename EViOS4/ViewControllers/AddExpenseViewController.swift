//
//  AddExpenseViewController.swift
//  EViOS4
//
//  Created by Student07 on 14/09/2023.
//

import UIKit
import CoreData

class AddExpenseViewController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var value: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    private var resultsController = DataManager.shared.getExpenseSectionResultsController()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        name.delegate = self
        value.delegate = self
        
        resultsController.delegate = self

        DataManager.shared.performFetch(resultsController)
    }
    
    @IBAction func actionBtnSave(_ sender: UIBarButtonItem) {
        guard let name = name.text,
              !name.isEmpty,
              let value = value.text,
              !value.isEmpty,
              let floatValue = Float(value),
              let indexPathSelected = tableView.indexPathForSelectedRow
        else {
            alertInvalidData()
            return
        }
        
        let selectedSection = resultsController.object(at: indexPathSelected)
        
        DataManager.shared.addExpense(
            name: name,
            value: floatValue,
            date: date.date,
            section: selectedSection
        )
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func alertInvalidData() {
        let alert = UIAlertController(
            title: "Invalid Data",
            message: "Please enter valid data",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        present(alert, animated: true)
    }
}

extension AddExpenseViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expenseSection = resultsController.object(at: indexPath)
        
        let cell = UITableViewCell()
        cell.textLabel?.text = expenseSection.name
        cell.selectionStyle = .gray
        
        return cell
    }
}

extension AddExpenseViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
}

extension AddExpenseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
