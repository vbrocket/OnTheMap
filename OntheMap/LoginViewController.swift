//
//  ViewController.swift
//  OntheMap
//
//  Created by Ibrahim.Moustafa on 3/2/16.
//  Copyright © 2016 Ibrahim.Moustafa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
let uclient = UdacityClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.delegate = self
        txtEmail.delegate = self
    }


    @IBAction func btnLoginClick(sender: AnyObject) {
        authenticatUdacity()
    }
    
    
    func LoginHandler(success: Bool,error: NSError?){
        
        if success {
            print("logged in success")
            uclient.getUserData({ (error) -> Void in
                if let _ = error {
                    dispatch_async(dispatch_get_main_queue(),{
                        self.showAlert("error retrieving user data")
                    })
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(),{
                        LoadingIndicatorView.hide();
                        self.performSegueWithIdentifier("segMap", sender: self)
                        
                    })
                }

            })
            
        }
        else
        {
            
            if let error = error {
                LoadingIndicatorView.hide();
                dispatch_async(dispatch_get_main_queue(),{
                    self.showAlert((error.userInfo[NSLocalizedDescriptionKey]!.description)!)
                })
            }
        }
    }
    
    func authenticatUdacity()
    {
        LoadingIndicatorView.show();
        uclient.Login(txtEmail.text!, Password: txtPassword.text!, completionHandlerForLogin: LoginHandler)
        
    }
    
   
    //MARK: Handle keyboard show hide.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // listen to keyboard notification
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // stop listening to keyboard before leaving view
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func subscribeToKeyboardNotifications() {
        // listen to keyoard show
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        // lesten to keyboard hide
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y = 0
        let availForKeyboard = view.frame.height - (txtPassword.frame.origin.y + txtPassword.frame.height)
        let spaceToShift = getKeyboardHeight(notification) - availForKeyboard
        if spaceToShift > 0
        {
            view.frame.origin.y -= spaceToShift
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // retutn view to it's original state when keyboard hide
        view.frame.origin.y = 0
    }
    
    // get keyboard height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }



    
    


}

