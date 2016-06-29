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
        print("SAVE")
    }
    
    
    @IBAction func dismissButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
