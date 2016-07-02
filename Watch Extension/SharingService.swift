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

    //Singleton Instance
    static let sharedInstance = SharingService()
    
    //Properties
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
    var phoneReachable: Bool {
        if let session = session {
            if session.reachable {
                return true
            }
        }
        
        return false
    }
    
    //MARK: - Messages
    
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
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        if let message = message["accounts"] as? [[String: AnyObject]] {
            NSNotificationCenter.defaultCenter().postNotificationName("UpdateAccounts", object: message)
        } else if let message = message["update"] as? [String: AnyObject] {
            NSNotificationCenter.defaultCenter().postNotificationName("UpdateCurrentAccount", object: message)
        }
    }
    
}
