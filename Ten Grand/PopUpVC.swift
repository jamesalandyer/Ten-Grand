//
//  PopUpVC.swift
//  Ten Grand
//
//  Created by James Dyer on 6/30/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class PopUpVC: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var quoteAuthorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var launchedBefore: Bool!
    
    var defaultQuote = "I'm convinced that about half of what separates successful entrepreneurs from the non-successful ones is pure perseverance.".uppercaseString
    var defaultQuoteAuthor = "- Steve Jobs".uppercaseString
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let popUpDate = formatDateToMMddyy(NSDate())
        NSUserDefaults.standardUserDefaults().setObject(popUpDate, forKey: "PreviousPopUpDate")
        
        if launchedBefore! {
            activityIndicator.startAnimating()
            welcomeLabel.text = "WELCOME BACK TO TEN GRAND"
            newLabel.hidden = true
            quoteLabel.hidden = false
            quoteAuthorLabel.hidden = false
            let parameters = [QuotesClient.Constants.QuotesParameterKeys.Category: QuotesClient.Constants.QuotesParameterValues.InspireCategory]
            QuotesClient.sharedInstance.taskForGETQuote(parameters, completionHandler: { (quote, author, error) in
                performUIUpdatesOnMain {
                    if error == nil {
                        if let author = author {
                            self.quoteAuthorLabel.text = "- \(author.uppercaseString)"
                        } else {
                            self.quoteAuthorLabel.text = "- UNKNOWN"
                        }
                        
                        if let quote = quote {
                            self.quoteLabel.text = "\"\(quote.uppercaseString)\""
                        } else {
                            self.quoteLabel.text = self.defaultQuote
                            self.quoteAuthorLabel.text = self.defaultQuoteAuthor
                        }
                    } else {
                        self.quoteLabel.text = self.defaultQuote
                        self.quoteAuthorLabel.text = self.defaultQuoteAuthor
                    }
                    self.activityIndicator.stopAnimating()
                }
                
            })
        } else {
            welcomeLabel.text = "WELCOME TO TEN GRAND"
            newLabel.hidden = false
            quoteLabel.hidden = true
            quoteAuthorLabel.hidden = true
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
