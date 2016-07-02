//
//  SharingService.swift
//  Ten Grand
//
//  Created by James Dyer on 7/1/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import WatchKit
import WatchConnectivity

class SharingService: NSObject, WCSessionDelegate {

    static let sharedInstance = SharingService()
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
    func sendMessage(message: [String: AnyObject], completionHandler: ((response: [String: AnyObject]?, error: NSError?) -> Void)?) {
        
        if WCSession.isSupported() {
            
            session = WCSession.defaultSession()
            
            if session!.reachable {
                session!.sendMessage(message, replyHandler: { (response) -> Void in
                    completionHandler?(response: response, error: nil)
                    }, errorHandler: { (error) -> Void in
                        completionHandler?(response: nil, error: error)
                })
            }
            
        }
        
    }
    
}
