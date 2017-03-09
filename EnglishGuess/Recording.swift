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
    
    var category:String?
    var id:String?
    var userName :String?
    var timeStamp:Int?
    var likes:Int?
    var dislikes:Int?
    var recordingUrl:String?
    var profileImageUrl:String?
    var chAnswer:String?
    var engAnswer:String?
    var totalClick:Int? = 0
    var correct:Int? = 0
    var correctRate:Double? = 0.0
    
    init (dictionary: [String:AnyObject]) {
        self.category = dictionary["category"]  as? String
        self.id = dictionary["id"]  as? String
        self.userName = dictionary["userName"]  as? String
        self.chAnswer = dictionary["chAnswer"]  as? String
        self.engAnswer = dictionary["engAnswer"]  as? String
        self.timeStamp = dictionary["timeStamp"] as? Int
        self.likes = dictionary["likes"] as? Int ?? 0
        self.dislikes = dictionary["dislikes"] as? Int ?? 0
        self.recordingUrl = dictionary["recordingUrl"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.totalClick = dictionary["totalClick"] as? Int ?? 0
        self.correct = dictionary["correct"] as? Int ?? 0
        self.correctRate = dictionary["correctRate"] as? Double ?? 0.0
    }
    func returnRecordingDict() -> [String:AnyObject] {
        
        return ["id":self.id as AnyObject, "userName":self.userName as AnyObject,"timeStamp":self.timeStamp as AnyObject,"likes":self.likes as AnyObject,"dislikes":self.dislikes as AnyObject,"recordingUrl":self.recordingUrl as AnyObject,"profileImageUrl":self.profileImageUrl as AnyObject,"chAnswer":self.chAnswer as AnyObject,"engAnswer":self.engAnswer as AnyObject,"totalClick":self.totalClick as AnyObject,"correct":self.correct as AnyObject,"correctRate":self.correctRate as AnyObject]
        
        
    }
    
}
