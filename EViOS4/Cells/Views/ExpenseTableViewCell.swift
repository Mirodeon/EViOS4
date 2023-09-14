//
//  ExpenseTableViewCell.swift
//  EViOS4
//
//  Created by Student07 on 14/09/2023.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var date: UILabel!
    
    let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(expense: Expense) {
        name.text = expense.name
        price.text = "\(expense.value)€"
        date.text = dateFormatter.string(from: expense.date)
    }
    
}
