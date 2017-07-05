//
//  User.swift
//  Simple-Twitter-Client
//
//  Created by Nhung on 7/1/17.
//  Copyright © 2017 Nhung. All rights reserved.
//

import Foundation

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: URL?
    var tagline: String?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        let imageURLString = dictionary["profile_image_url_https"] as? String
        if let imageURLString = imageURLString {
            profileImageUrl = URL(string: imageURLString)
        }
        tagline = dictionary["description"] as? String
        
    }
    
    
}
