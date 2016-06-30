//
//  InfoVC.swift
//  Ten Grand
//
//  Created by James Dyer on 6/28/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {

    @IBOutlet weak var dismissButtonConstraint: NSLayoutConstraint!
    
    var animEngineButtons: AnimationEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animEngineButtons = AnimationEngine(constraints: [dismissButtonConstraint])
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animEngineButtons.animateOnScreen()
    }

    @IBAction func dismissButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
