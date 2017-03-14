//
//  numberOfQLabel+admob.swift
//  EnglishGuess
//
//  Created by 吳建豪 on 2017/3/10.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import Firebase
import UnityAds

var inProcess = false
var rewardBasedVideo: GADRewardBasedVideoAd?
class TodayCompletedQuestionLabel:UILabel, GADRewardBasedVideoAdDelegate {
    
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        //      rewardBasedVideo?.delegate = self
        reloadAd()
        text = "今日答錯題數:\(UserDefaults.numberOfQInToday())/\(UserDefaults.userAnswerQuota())"
        textAlignment = .center
        textColor = UIColor.white
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playVideo)))
    }
    
   
    var delegateController:UIViewController?
    func update(){
        if String(UserDefaults.numberOfQInToday()) == UserDefaults.userAnswerQuota() {
           text = "次數已滿 點擊回覆"
        } else {
            text = "今日答錯題數:\(UserDefaults.numberOfQInToday())/\(UserDefaults.userAnswerQuota())"
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func playVideo(){
        if rewardBasedVideo?.isReady == true, UserDefaults.numberOfQInToday()
            >= UserDefaults.userUploadQuota() {
            UIWindow.removeStatusBar()
            rewardBasedVideo?.present(fromRootViewController: delegateController!)
        }
    }
    
    func reloadAd(){
        if inProcess == false {
            inProcess = true
            rewardBasedVideo = GADRewardBasedVideoAd.sharedInstance()
            rewardBasedVideo?.delegate = self
            rewardBasedVideo?.load(GADRequest(),
                                   withAdUnitID: "ca-app-pub-8818309556860374/8167494449")
        }
        
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
    print("Reward based video ad failed to load: \(error.localizedDescription)")
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        
    print("Reward based video ad is received.")
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
        UIWindow.addStatusBar()
        inProcess = false
        reloadAd()
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
      guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
      UserDefaults.standard.set(0, forKey: uid+Date.returnTodayString())
      text = "今日答錯題數:0/\(UserDefaults.userAnswerQuota())"
    //  update()
    }
    

}
