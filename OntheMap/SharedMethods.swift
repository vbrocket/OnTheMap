//
//  UIViewController.swift
//  OntheMap
//
//  Created by Ibrahim.Moustafa on 4/29/16.
//  Copyright © 2016 Ibrahim.Moustafa. All rights reserved.
//

import UIKit

extension UIViewController {

    func showAlert(Message: String){
        let vcAlert = UIAlertController(title: "Error", message: Message, preferredStyle: UIAlertControllerStyle.Alert)
        vcAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
        self.presentViewController(vcAlert, animated: true, completion: nil)
    }
    
    func LogoutUdacity(){
        LoadingIndicatorView.show()
        UdacityClient.sharedInstance().Logout { (success, error) -> Void in
            if success == true{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        LoadingIndicatorView.hide()
                    self.performSegueWithIdentifier("segLogout", sender: self)
                })
            }       	          else {
                if let error = error {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        LoadingIndicatorView.hide()
                        self.showAlert((error.userInfo[NSLocalizedDescriptionKey]!.description)!)
                    })
                }
            }
        }
    }
}
