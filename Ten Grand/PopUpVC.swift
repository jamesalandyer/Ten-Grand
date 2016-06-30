//
//  PopUpVC.swift
//  Ten Grand
//
//  Created by James Dyer on 6/30/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class PopUpVC: UIViewController {

    //Outlets
    @IBOutlet weak private var welcomeLabel: UILabel!
    @IBOutlet weak private var newLabel: UILabel!
    @IBOutlet weak private var quoteLabel: UILabel!
    @IBOutlet weak private var quoteAuthorLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    //Properties
    var launchedBefore: Bool!
    
    private var defaultQuote = "I'm convinced that about half of what separates successful entrepreneurs from the non-successful ones is pure perseverance.".uppercaseString
    private var defaultQuoteAuthor = "- Steve Jobs".uppercaseString
    
    //MARK: - Stack
    
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
            //Gets the quote of the day
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
    
    //MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
