//
//  AddAccountVC.swift
//  Ten Grand
//
//  Created by James Dyer on 6/27/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class AddAccountVC: UIViewController, UITextFieldDelegate {

    //Outlets
    @IBOutlet weak private var accountNameTextField: UITextField!
    @IBOutlet weak private var createButton: CustomButton!
    @IBOutlet weak private var logoImageView: UIImageView!
    @IBOutlet weak var createButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonConstraint: NSLayoutConstraint!
    
    //Properties
    private var animEngineButtons: AnimationEngine!
    
    //MARK: - Stack
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accountNameTextField.delegate = self
        
        animEngineButtons = AnimationEngine(constraints: [createButtonConstraint, cancelButtonConstraint])
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animEngineButtons.animateOnScreen()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: - Actions
    
    @IBAction func createButtonPressed(sender: AnyObject) {
        let accountName = accountNameTextField.text
        
        func showFailed() {
            createButton.borderColor = redColor
            NSTimer.scheduledTimerWithTimeInterval(0.35, target: self, selector: #selector(revertButton), userInfo: nil, repeats: false)
        }
        
        guard accountName != "" else {
            showFailed()
            return
        }
        
        guard !isEmptyOrContainsOnlySpaces(accountName!) else {
            showFailed()
            accountNameTextField.text = ""
            return
        }
        
        let newAccount = Account(name: accountName!, balance: 0.00, time: 0.00, context: CoreDataStack.stack.context)
        
        let notif = NSNotification(name: "AddAccount", object: newAccount)
        NSNotificationCenter.defaultCenter().postNotification(notif)
        NSNotificationCenter.defaultCenter().postNotificationName("AccountsChanged", object: nil)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
     Reverts the button color back to the original color.
     */
    func revertButton() {
        createButton.borderColor = greenColor
    }
    
    //MARK: - TextField
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    //MARK: - Keyboard
    
    /**
     Subscribes to the keyboard will show and hide notifications.
     */
    private func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /**
     Unsubscribes from the keyboard will show and hide notifications.
     */
    private func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /**
     Adjusts the screen when the keyboard shows and hides the top button.
     
     - Parameter notification: The notification being passed through.
     */
    func keyboardWillShow(notification: NSNotification) {
        logoImageView.hidden = true
        view.frame.origin.y = getKeyboardHeight(notification) * -0.25
    }
    
    /**
     Adjusts the screen when the keyboard hides.
     
     - Parameter notification: The notification being passed through.
     */
    func keyboardWillHide(notification: NSNotification) {
        logoImageView.hidden = false
        view.frame.origin.y = 0
    }
    
    /**
     Gets the users keyboard height.
     
     - Parameter notification: The notification being passed through.
     */
    private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        accountNameTextField.resignFirstResponder()
    }

}
