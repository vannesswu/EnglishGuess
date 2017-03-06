//
//  recordViewController.swift
//  EnglishGuess
//
//  Created by 吳建豪 on 2017/3/7.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import LBTAComponents
import Firebase


class RecordViewController : UIViewController {
    
    var category:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = category ?? ""
    }
    override func viewWillLayoutSubviews() {
        setupTopicView()
        setupRecordButtonView()
        setupHintView()
        
        
    }
    let topicLabel :UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.darkText
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.adjustsFontForContentSizeCategory = true
        label.backgroundColor = UIColor.lightGray
        label.numberOfLines = 0
        return label
    }()
    func setupTopicView() {
       view.addSubview(topicLabel)
       topicLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.size.height/4)
        topicLabel.text = "題目為:吊橋\n suspension bridge"
    }
    
    let timerLabel:UILabel = {
        let label = UILabel()
        label.text = "15.0"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 60)
        return label
    }()
    
    lazy var recordButton:UIButton = {
         let btn = UIButton()
         btn.setTitle("開始錄音", for: .normal)
         btn.backgroundColor = UIColor.mainBlue
         btn.setTitleColor(UIColor.white, for: .normal)
         btn.layer.cornerRadius = 15
         btn.clipsToBounds = true
         btn.addTarget(self, action: #selector(startRecording), for: .touchUpInside)
         return btn
    }()
    lazy var playButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("播放錄音", for: .normal)
        btn.backgroundColor = UIColor.mainBlue
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.isEnabled = false
        btn.alpha = 0.5
        btn.layer.cornerRadius = 15
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(playRecording), for: .touchUpInside)
        return btn
    }()
    lazy var uploadButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("上傳錄音", for: .normal)
        btn.backgroundColor = UIColor.mainBlue
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.isEnabled = false
        btn.alpha = 0.5
        btn.layer.cornerRadius = 15
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(uploadRecording), for: .touchUpInside)
        return btn
    }()
    lazy var btnHeight:CGFloat = { self.view.frame.size.height/10 - 10 }()
    
    func setupRecordButtonView() {
        view.addSubview(timerLabel)
        view.addSubview(recordButton)
        view.addSubview(playButton)
        view.addSubview(uploadButton)
        
        timerLabel.anchor(topicLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 300, heightConstant: self.view.frame.size.height/8)
        timerLabel.anchorCenterXToSuperview()
        
        recordButton.anchor(timerLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: btnHeight)
        recordButton.anchorCenterXToSuperview()
        
        playButton.anchor(recordButton.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: btnHeight)
        playButton.anchorCenterXToSuperview()
        
        
        uploadButton.anchor(playButton.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: btnHeight)
        uploadButton.anchorCenterXToSuperview()
        
        
    }
    var countdowntimer = Timer()
    let numberFormatter:NumberFormatter = {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 1
        nf.minimumIntegerDigits = 1
        return nf
    }()
    var countdownTime = 15.0
    func startRecording() {
     
     countdownTime = 15.0
     countdowntimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(countdownTimer), userInfo: nil, repeats: true)
     recordButton.isEnabled = false
     recordButton.alpha = 0.5
     playButton.isEnabled = false
     playButton.alpha = 0.5
     uploadButton.isEnabled = false
     uploadButton.alpha = 0.5
        
    }
    func countdownTimer() {
        
        countdownTime -= 0.1
        DispatchQueue.main.async {
          self.timerLabel.text = "\(self.numberFormatter.string(from: NSNumber(value: self.countdownTime))!)"
            if ( self.timerLabel.text == "0.0"){
                self.countdowntimer.invalidate()
                self.recordButton.isEnabled = true
                self.playButton.isEnabled = true
                self.uploadButton.isEnabled = true
                self.recordButton.alpha = 1
                self.playButton.alpha = 1
                self.uploadButton.alpha = 1
            }
        
        }
        
        
    }
    func playRecording() {
        
    }
    
    func uploadRecording() {
        
        
    }
    
    func setupHintView() {
        
        let hintLabel = UILabel()
        hintLabel.numberOfLines = 0
        view.addSubview(hintLabel)
        hintLabel.font = UIFont.systemFont(ofSize: 18)
        hintLabel.textColor = UIColor.init(r: 210, g: 210, b: 210)
        hintLabel.anchor(uploadButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 50, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        hintLabel.text = "溫馨小提示:請不要直接說出題目中英文翻譯裡的任一單字，盡量以英文形容該題目的特色與行為等，時間只有15秒，加油！"
        
    }
    
}
