//
//  ExpenseViewController.swift
//  EViOS4
//
//  Created by Student07 on 14/09/2023.
//

import UIKit
import CoreData

class ExpenseViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var resultsController = DataManager.shared.getExpenseResultsController()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName: "ExpenseTableViewCell", bundle: nil),
            forCellReuseIdentifier: "ExpenseTableViewCell"
        )
        
        resultsController.delegate = self

        DataManager.shared.performFetch(resultsController)
    }
    
    @IBAction func actionBtnAdd(_ sender: UIBarButtonItem) {
        if let vc = storyboard?.instantiateViewController(identifier: "AddExpense") {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ExpenseViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        resultsController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expense = resultsController.object(at: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier:"ExpenseTableViewCell",
            for: indexPath
        ) as? ExpenseTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setupCell(expense: expense)
        
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let expense = resultsController.object(at: indexPath)
            DataManager.shared.deleteExpense(expense)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        resultsController.sections?[section].name
    }
}

extension ExpenseViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections([sectionIndex], with: .automatic)
        case .delete:
            tableView.deleteSections([sectionIndex], with: .automatic)
        default:
            break
        }
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
