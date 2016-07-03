//
//  StoreDetailVC.swift
//  Ten Grand
//
//  Created by James Dyer on 6/27/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class StoreDetailVC: UIViewController {

    //Outlets
    @IBOutlet weak private var detailImageView: UIImageView!
    @IBOutlet weak private var detailTitle: UILabel!
    @IBOutlet weak private var detailLabel: UILabel!
    @IBOutlet weak private var buyButton: CustomButton!
    @IBOutlet weak var buyButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var dismissButtonConstraint: NSLayoutConstraint!
    
    //Properties
    var bank: Bank!
    var item: StoreItem!
    private var animEngineButtons: AnimationEngine!
    
    //MARK: - Stack
    
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
        
        animEngineButtons = AnimationEngine(constraints: [buyButtonConstraint, dismissButtonConstraint])
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animEngineButtons.animateOnScreen()
    }
    
    //MARK: - Actions

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
    
    @IBAction func dismissButtonPressed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Purchase
    
    /*
     Tries to purchase the item selected.
     
     - Parameter item: The item that is being purchased.
     
     - Returns: A Bool of whether the purchase went through.
     */
    private func purchaseSuccessful(item: StoreItem) -> Bool {
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
    
    /*
     Reverts the button back to the original color.
     */
    func revertButton() {
        buyButton.borderColor = greenColor
    }
    
}
