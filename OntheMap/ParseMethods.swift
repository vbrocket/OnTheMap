//
//  ParseMethods.swift
//  OntheMap
//
//  Created by Ibrahim.Moustafa on 4/4/16.
//  Copyright © 2016 Ibrahim.Moustafa. All rights reserved.
//

import Foundation
extension ParseClient {
    
    
  
    func getStudentLocations(NumberOfStudents: Int, completionHandlerForGetStudentLocation: (success: Bool, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = ["limit": NumberOfStudents, "order": "-updatedAt"]
        
        let mutableMethod: String = "StudentLocation"
        
        /* 2. Make the request */
        taskForGETMethod(mutableMethod, parameters: parameters as! [String : AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForGetStudentLocation(success: false,error: error)
            } else {
                
                if let locations = results as? [NSObject: NSObject] {
                    if let usersResult = locations["results"] as? [[String : AnyObject]] {
                        StudentInformation.arrStudentInformation = StudentInformation.convertFromDictionaries(usersResult)
                        completionHandlerForGetStudentLocation(success: true, error: nil)
                    }
                }
                else {
                completionHandlerForGetStudentLocation(success: false,error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse StudentLocations"]))
                }
                
            }
        }
    }
    
    func PostStudentLocation(latitude: Double, longitude: Double, mediaURL: String, mapString: String, completionHandlerForPostNewLocation: (success: Bool, error: NSError?) -> Void) {
        let udacityClient = UdacityClient()
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String: AnyObject]()
        var mutableMethod: String = "StudentLocation"
        let jsonBody: String  = "{\"uniqueKey\": \"\(UdacityClient.userID!)\", \"firstName\": \"\(UdacityClient.user_firstname!)\", \"lastName\": \"\(UdacityClient.user_lastname!)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        /* 2. Make the request */
        taskForPOSTMethod(mutableMethod, parameters: parameters, jsonBody: jsonBody ) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForPostNewLocation(success: false, error: error)
            } else {
                print(results)
                let createdAt = results["createdAt"] as? String
                let objectId = results["objectId"] as? String
                
                if let _ = createdAt,let _ = objectId {
                        completionHandlerForPostNewLocation(success: true, error: nil)
                    }
                else {
                    completionHandlerForPostNewLocation(success: false, error: NSError(domain: "PostStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse PostStudentLocation"]))
                }
            }
        }
        
    }
    
    
    
}