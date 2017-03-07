//
//  User.swift
//  EnglishGuess
//
//  Created by 吳建豪 on 2017/3/6.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation

class User : NSObject {
    var id: String?
    var name:String?
    var email:String?
    var profileImageUrl:String?
    var recordings:[Recording]?
    
    init (dictionary: [String:AnyObject]) {
        
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.recordings = dictionary["recordings"] as? [Recording]
        
        
    }
    

}
