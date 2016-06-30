//
//  StoreDetailVC.swift
//  Ten Grand
//
//  Created by James Dyer on 6/27/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class StoreDetailVC: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var buyButton: CustomButton!
    
    var bank: Bank!
    var item: StoreItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let detailImage = UIImage(named: "\(item.name!)_detail")
        detailImageView.image = detailImage
        
        detailTitle.text = "\(item.name!.uppercaseString)"
        detailLabel.text = "\(item.detail!.uppercaseString)"
        
        if item.owned!.boolValue {
            buyButton.hidden = true
        } else {
            buyButton.hidden = false
            buyButton.setTitle("BUY: \(formatMoneyIntoString(item.price!.doubleValue))", forState: .Normal)
        }
    }

    @IBAction func buyButtonPressed(sender: AnyObject) {
        if purchaseSuccessful(item) {
            buyButton.hidden = true
            item.owned = true
            CoreDataStack.stack.save()
        } else {
            buyButton.borderColor = redColor
            NSTimer.scheduledTimerWithTimeInterval(0.35, target: self, selector: #selector(revertButton), userInfo: nil, repeats: false)
        }
    }
    
    
    @IBAction func dismissButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func purchaseSuccessful(item: StoreItem) -> Bool {
        let cash = bank.cash!.doubleValue
        let purchasePrice = item.price!.doubleValue
        
        if cash >= purchasePrice {
            bank.cash! = cash - purchasePrice
            let notif = NSNotification(name: "Purchased", object: nil)
            NSNotificationCenter.defaultCenter().postNotification(notif)
            return true
        } else {
            return false
        }
        
    }
    
    func revertButton() {
        buyButton.borderColor = greenColor
    }
    
}
