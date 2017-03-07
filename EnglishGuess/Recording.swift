//
//  record.swift
//  EnglishGuess
//
//  Created by 吳建豪 on 2017/3/7.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import Firebase

class Recording : NSObject {
    
    var userName :String?
    var timeStamp:Int?
    var likes:Int?
    var dislikes:Int?
    var recordingUrl:String?
    var profileImageUrl:String?
    var answer:String?
    
    init (dictionary: [String:AnyObject]) {
        
        self.userName = dictionary["userName"]  as? String
        self.answer = dictionary["answer"]  as? String
        self.timeStamp = dictionary["timeStamp"] as? Int
        self.likes = dictionary["likes"] as? Int ?? 0
        self.dislikes = dictionary["dislikes"] as? Int ?? 0
        self.recordingUrl = dictionary["recordingUrl"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String

    }
    
    
}
