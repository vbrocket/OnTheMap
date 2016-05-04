//
//  ParseConstants.swift
//  OntheMap
//
//  Created by Ibrahim.Moustafa on 4/4/16.
//  Copyright © 2016 Ibrahim.Moustafa. All rights reserved.
//

import Foundation
extension ParseClient{
    
    
    // MARK: Constants
    struct Constants {
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "api.parse.com"
        static let ApiPath = "/1/classes/"
    }
    
    struct JSONResponseKeys {
        
        static let objectId: String = "objectId"
        static let uniqueKey: String = "uniqueKey"
        static let firstName: String = "firstName"
        static let lastName: String = "lastName"
        static let mapString: String = "mapString"
        static let mediaURL: String = "mediaURL"
        static let latitude: String = "latitude"
        static let longitude: String = "longitude"
        
        
    }
    
}