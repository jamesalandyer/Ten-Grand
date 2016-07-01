//
//  AccountsIC.swift
//  Ten Grand
//
//  Created by James Dyer on 6/30/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class AccountsIC: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var accountsTable: WKInterfaceTable!
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
    var accounts: String = "HELLO"
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }
    
    override func didAppear() {
        super.didAppear()
        
        if WCSession.isSupported() {
            // 2
            session = WCSession.defaultSession()
            // 3
            session!.sendMessage(["bank": accounts], replyHandler: { (response) -> Void in
                // 4
                print("TEST")
                }, errorHandler: { (error) -> Void in
                    // 6
                    print(error)
            })
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
