//
//  InfoVC.swift
//  Ten Grand
//
//  Created by James Dyer on 6/28/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {

    //Outlets
    @IBOutlet weak var dismissButtonConstraint: NSLayoutConstraint!
    
    //Properties
    private var animEngineButtons: AnimationEngine!
    
    //MARK: - Stack
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animEngineButtons = AnimationEngine(constraints: [dismissButtonConstraint])
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animEngineButtons.animateOnScreen()
    }

    //MARK: - Actions
    
    @IBAction func dismissButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
