//
//  SectionViewController.swift
//  EViOS4
//
//  Created by Student07 on 14/09/2023.
//

import UIKit
import CoreData

class SectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var resultsController = DataManager.shared.getExpenseSectionResultsController()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        resultsController.delegate = self

        DataManager.shared.performFetch(resultsController)
    }
    
    @IBAction func actionBtnAdd(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(
            title: "New Section",
            message: "Enter the name of the new Section",
            preferredStyle: .alert
        )

        alert.addTextField {field in
            field.placeholder = "Name...?"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            
            guard let fieldText = alert.textFields?.first?.text,
                  !fieldText.isEmpty
            else { return }

            DataManager.shared.addExpenseSection(name: fieldText)
        }))

        present(alert, animated: true)
    }
}

extension SectionViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expenseSection = resultsController.object(at: indexPath)
        
        let cell = UITableViewCell()
        cell.textLabel?.text = expenseSection.name
        cell.selectionStyle = .none
        
        return cell
    }

//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        true
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let expenseSection = resultsController.object(at: indexPath)
//            DataManager.shared.deleteExpenseSection(expenseSection)
//        }
//    }
}

extension SectionViewController: NSFetchedResultsControllerDelegate {
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
