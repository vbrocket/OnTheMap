//
//  File.swift
//  OntheMap
//
//  Created by Ibrahim.Moustafa on 4/5/16.
//  Copyright © 2016 Ibrahim.Moustafa. All rights reserved.
//


import Foundation
import MapKit

struct StudentInformation {
    
    static var arrStudentInformation: [StudentInformation] = []
    
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: CLLocationDegrees = CLLocationDegrees()
    var longitude: CLLocationDegrees = CLLocationDegrees()
    
    /* Initial a student information from dictionary */
    init(dictionary: [String : AnyObject]) {
        objectId = dictionary[ParseClient.JSONResponseKeys.objectId] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.uniqueKey] as! String
        mapString = dictionary[ParseClient.JSONResponseKeys.mapString] as! String
        
        firstName = dictionary[ParseClient.JSONResponseKeys.firstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.lastName] as! String
        latitude = dictionary[ParseClient.JSONResponseKeys.latitude] as! CLLocationDegrees
        longitude = dictionary[ParseClient.JSONResponseKeys.longitude] as! CLLocationDegrees
        mediaURL = dictionary[ParseClient.JSONResponseKeys.mediaURL] as! String
        
    }
    
    
    /* Convert an array of dictionaries to an array of student information struct objects */
    static func convertFromDictionaries(array: [[String : AnyObject]]) -> [StudentInformation] {
        var resultArray = [StudentInformation]()
        
        for dictionary in array {
            resultArray.append(StudentInformation(dictionary: dictionary))
        }
        
        return resultArray
    }
}