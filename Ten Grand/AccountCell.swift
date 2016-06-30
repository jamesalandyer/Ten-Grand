//
//  AccountCell.swift
//  Ten Grand
//
//  Created by James Dyer on 6/28/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountBalanceLabel: UILabel!
    @IBOutlet weak var progressViewWidth: NSLayoutConstraint!
    
    func configureCell(account: Account, width: CGFloat) {
        if NSUserDefaults.standardUserDefaults().objectForKey("\(account.objectID)StartDate") != nil && NSUserDefaults.standardUserDefaults().objectForKey("\(account.objectID)StoppedDate") == nil {
            accountNameLabel.textColor = greenColor
        } else {
            accountNameLabel.textColor = UIColor(red: 64.0 / 255.0, green: 64.0 / 255.0, blue: 64.0 / 255.0, alpha: 1.0)
        }
        
        accountNameLabel.text = account.name!.uppercaseString
        
        let accountBalance = account.balance!.doubleValue
        accountBalanceLabel.text = formatMoneyIntoString(accountBalance)
        
        let progressWidth = (width / 10000) * CGFloat(accountBalance)
        progressViewWidth.constant = progressWidth
        
    }

}
