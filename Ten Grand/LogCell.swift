//
//  LogCell.swift
//  Ten Grand
//
//  Created by James Dyer on 6/28/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class LogCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    func configureCell(deposit: Deposit) {
        let date = deposit.date!
        
        dateLabel.text = formatDateToMMddyy(date)
        
        let amount = deposit.amount as! Double
        amountLabel.text = "$ \(formatTimeIntoLongCurrency(amount))"
    }

}
