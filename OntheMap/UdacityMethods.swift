//
//  UdacityMethods.swift
//  OntheMap
//
//  Created by Ibrahim.Moustafa on 3/8/16.
//  Copyright © 2016 Ibrahim.Moustafa. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    
    func Login(Username: String,Password: String, completionHandlerForLogin: (success: Bool, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String: AnyObject]()
        let mutableMethod: String = "session"
        let jsonBody: String  = "{\"udacity\": {\"username\": \"\(Username)\", \"password\": \"\(Password)\"}}"
        /* 2. Make the request */
        taskForPOSTMethod(mutableMethod, parameters: parameters, jsonBody: jsonBody ) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForLogin(success: false, error: error)
            } else {
                print(results)
                let account = results["account"] as? [String: AnyObject]
                let session = results["session"] as? [String: AnyObject]
                
                if let account = account,let _ = session {
                    let registered = account["registered"] as? Int
                    UdacityClient.userID = account["key"] as? String
                        if registered == 1 &&  UdacityClient.userID != nil {
                            completionHandlerForLogin(success: true, error: nil)
                        }
                        else
                        {
                            completionHandlerForLogin(success: false, error: NSError(domain: "Unregisterd", code: 0, userInfo: [NSLocalizedDescriptionKey: "user is unregistered"]))
                        }
                    
                } else {
                    completionHandlerForLogin(success: false, error: NSError(domain: "Login parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse request"]))
                }
            }
        }

    }
    
    func Logout(completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String: AnyObject]()
        let mutableMethod: String = "session"

        /* 2. Make the request */
        taskForDELETEMethod(mutableMethod, parameters: parameters) { (result, error) -> Void in
            
            if let error = error {
                completionHandler(success: false, error: error)
            } else {
                print(result)
                let session = result["session"] as? [String: AnyObject]
                if let _ = session {
                   completionHandler(success: true, error: nil)
                } else {
                    completionHandler(success: false, error: NSError(domain: "Logout parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse logout"]))
                }
            }
        }
        
    }
    
    func getUserData(completionHandlerGetUserData: (error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String: AnyObject]()
        
        let mutableMethod: String = "users/\(UdacityClient.userID!)"
        
        /* 2. Make the request */
        taskForGETMethod(mutableMethod, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerGetUserData(error: error)
            } else {
                print(results)
                if let userdata = results["user"] as? [String:AnyObject] {
                    UdacityClient.user_firstname = userdata["first_name"] as? String
                    UdacityClient.user_lastname = userdata["last_name"] as? String

                    completionHandlerGetUserData(error: nil)
                    
                } else {
                    completionHandlerGetUserData(error: NSError(domain: "getUserData parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getUserData"]))
                }
            }
        }
    }

    
}