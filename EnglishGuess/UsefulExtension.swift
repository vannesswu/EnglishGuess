//
//  File.swift
//  parseHtmltest
//
//  Created by 吳建豪 on 2017/2/22.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import LBTAComponents
import Firebase

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
    func return1to9(with str:String) -> String {
        let nString = String(str.characters.filter({ (character:Character) -> Bool in
            if character >= "0" && character <= "9" || character == "."{
                return true
            } else {return false }
        }))
        return nString
    }
    func return0to9() -> String {
        let nString = String(self.characters.filter({ (character:Character) -> Bool in
            if character >= "0" && character <= "9" || character == "."{
                return true
            } else {return false }
        }))
        return nString
    }
}

extension UIColor {
    static let mainBlue = {
        return UIColor(r: 93, g: 201, b: 234)
    }()
    static let darkBlue = {
        return UIColor(r: 12, g: 75, b: 94)
    }()
    static let selectGreen = {
        return UIColor(r: 57, g: 199, b: 50)
    }()
    static let htmlBlue = {
        return UIColor(r: 85, g: 135, b: 253)
    }()
    static let lightGray = {
        return UIColor(r: 240, g: 240, b: 240)
    }()
    static let midleGray = {
        return UIColor(r: 135, g: 135, b: 135)
    }()
    
    static let adoptBlue = {
        return UIColor(r: 51, g: 139, b: 227)
    }()
    static let adoptGreen = {
        return UIColor(r: 21, g: 175, b: 132)
    }()
    static let adoptPupple = {
        return UIColor(r: 116, g: 72, b: 212)
    }()
    static let adoptRed = {
        return UIColor(r: 254, g: 88, b: 128)
    }()
    static let valid = {
        return UIColor(r: 47, g: 68, b: 86)
    }()
    
    static let buyRed = {
        return UIColor(r: 247, g: 70, b: 77)
    }()
    static let titleViewCyan = {
        return UIColor(r: 117, g: 232, b: 206)
    }()
    static let darkGreen = {
        return UIColor(r: 18, g: 110, b: 131)
    }()
    static let midleBlue = {
        return UIColor(r: 52, g: 138, b: 164)
    }()
    
}

extension UIView {
    
    static func makeSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        return view
    }
    
    static let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        return view
    }()
}

class SeparatorView:UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(r: 230, g: 230, b: 230)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
class TitleLabel:UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.systemFont(ofSize: 15)
        adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class NumberTextField:UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 15)
        adjustsFontSizeToFitWidth = true
        keyboardType = .numbersAndPunctuation
        placeholder = "請輸入數字"
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HearderLabel:UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.boldSystemFont(ofSize: 20)
        adjustsFontSizeToFitWidth = true
        //  backgroundColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension UIActivityIndicatorView {
    static let spinner: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        return aiv
    }()
}


extension UserDefaults {
    
    static func isHideOverDateSetting() -> Bool {
        if let bool = UserDefaults.standard.object(forKey: "isHideOverDateSetting") as? Bool {
            return bool
        }
        return false
    }
    static func isDailyNeedRemind() -> Bool? {
        if let bool = UserDefaults.standard.object(forKey: "isNeedRemind") as? Bool {
            return bool
        }
        return nil
    }
    static func remindTime() -> Date? {
        if let remindTime = UserDefaults.standard.object(forKey: "remindTime") as? Date {
            return remindTime
        }
        return nil
    }
    static func clickNumber() -> Int {
        if let clickNumber = UserDefaults.standard.object(forKey: "clickNumber") as? Int {
            return clickNumber
        }
        return 0
    }
    static func numberOfQInToday() -> Int {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return 0}
        if let number = UserDefaults.standard.object(forKey: uid + Date.returnTodayString()) as? Int {
            return number
        }
        return 0
    }
    static func numberOfUpload() -> Int {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return 0}
        if let number = UserDefaults.standard.object(forKey: "\(uid)EnglishGuessUpload") as? Int {
            return number
        }
        return 0
    }
    static func userUploadQuota() -> Int {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return 10}
        if let number = UserDefaults.standard.object(forKey: "\(uid)userUploadQuota") as? Int {
            return number
        }
        return 10
    }
    static func userAnswerQuotaForJudge() -> Int {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return 10}
        if let number = UserDefaults.standard.object(forKey: "\(uid)userAnswerQuotaForJudge") as? Int {
            return number
        }
        return 10
    }
    static func userAnswerQuota() -> String {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return "10"}
        if let number = UserDefaults.standard.object(forKey: "\(uid)userAnswerQuota") as? String {
            return number
        }
        return "10"
    }
    
}

extension Date {
    
    static func returnTodayString() -> String {
    let date = Date()
    let formater = DateFormatter()
    formater.dateStyle = .short
    return formater.string(from: date)
    
    }
}

extension UISegmentedControl{
    func changeTitleFont(newFontName:String?, newFontSize:CGFloat?){
        let attributedSegmentFont = NSDictionary(object: UIFont(name: newFontName!, size: newFontSize!)!, forKey: NSFontAttributeName as NSCopying)
        setTitleTextAttributes(attributedSegmentFont as [NSObject : AnyObject], for: .normal)
    }
}


extension UIWindow {
    static func addStatusBar(){
        let statusBarBackgroundView = UIView()
        statusBarBackgroundView.backgroundColor = UIColor.darkBlue
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(statusBarBackgroundView)
            window.addConstraintsWithFormat("H:|[v0]|", views: statusBarBackgroundView)
            window.addConstraintsWithFormat("V:|[v0(20)]", views: statusBarBackgroundView)
        }
    }
    static func removeStatusBar(){
        if let window = UIApplication.shared.keyWindow {
            for view in window.subviews {
                if view.backgroundColor == UIColor.darkBlue {
                    view.removeFromSuperview()
                }
            }
        }
   }
}

extension UIButton {

   static func makeCatButton(title:String) -> UIButton {

        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.addTarget(HomeViewController(), action: #selector(HomeViewController.handleCatButtonPress), for: .touchUpInside)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.adoptBlue
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: -2, height: 2)
        btn.layer.shadowOpacity = 0.8
        btn.layer.shadowRadius = 2.0

        return btn
    }

}


class UploadQuestionLabel:UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .center
        textColor = UIColor.white
        text = "已上傳題數:\(UserDefaults.numberOfUpload())/\(UserDefaults.userUploadQuota())"
    }
    func update() {
        text = "已上傳題數:\(UserDefaults.numberOfUpload())/\(UserDefaults.userUploadQuota())"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
