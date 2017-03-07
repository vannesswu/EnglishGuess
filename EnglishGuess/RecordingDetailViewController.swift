//
//  recordingDetailViewController.swift
//  EnglishGuess
//
//  Created by 吳建豪 on 2017/3/8.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import UIKit
import LBTAComponents
import AVFoundation

class RecordingDetailViewController:UIViewController {
    
    
    var recording:Recording?
    var audioPlayer:AVAudioPlayer!
    var recordingSession: AVAudioSession!
    var recordingData:Data?
    var isNeedAddHeight = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        recordingSession = AVAudioSession.sharedInstance()
        do {
            //     try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with:.defaultToSpeaker)
            try recordingSession.setActive(true)
        } catch {
            // failed to record!
        }
        
        fetchRecordingData { (data) in
            self.recordingData = data
            self.setupViews()

        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(RecordingDetailViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RecordingDetailViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        adjustInsetForKeyboardShow(true, notification: notification)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        adjustInsetForKeyboardShow(false, notification: notification)
        isNeedAddHeight = true
    }
    func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
        if isNeedAddHeight || show == false {
            let userInfo = notification.userInfo ?? [:]
            let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            let adjustmentHeight = keyboardFrame.height  * (show ? 1 : -1)
            
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -adjustmentHeight)
            isNeedAddHeight = false
        }
    }
    
    lazy var PlayButton:UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        btn.backgroundColor = UIColor.mainBlue
        btn.addTarget(self, action: #selector(playrecording), for: .touchUpInside)
        return btn
    }()
    lazy var anserTextField:UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.textAlignment = .center
        tf.placeholder = "請輸入您的答案"
        return tf
    }()
    lazy var checkAnswerButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("確認送出", for: .normal)
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: -1.5, height: 1.5)
        btn.backgroundColor = UIColor.adoptRed
        btn.layer.cornerRadius = 15
        btn.layer.shadowOpacity = 0.8
        btn.layer.shadowRadius = 1.0
        btn.addTarget(self, action: #selector(checkAnswer), for: .touchUpInside)
        return btn
    }()
    let separatorView = UIView.makeSeparatorView()
    func setupViews() {
        view.addSubview(PlayButton)
        view.addSubview(anserTextField)
        view.addSubview(checkAnswerButton)
        view.addSubview(separatorView)
        
        PlayButton.anchorCenterSuperview()
        PlayButton.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 150)
        anserTextField.anchor(PlayButton.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 140, heightConstant: 30)
        anserTextField.anchorCenterXToSuperview()
        separatorView.anchor(nil, left:anserTextField.leftAnchor, bottom: anserTextField.bottomAnchor, right: anserTextField.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        checkAnswerButton.anchor(anserTextField.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 15, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 140, heightConstant: 30)
        checkAnswerButton.anchorCenterXToSuperview()
        
    }
    
    func checkAnswer() {
        guard let userAnswer = anserTextField.text ,let answer = recording?.answer else { return }
        
        if userAnswer == answer {
            
        }
        
    }
    
    
    
    func playrecording() {
        PlayButton.isEnabled = false
        PlayButton.alpha = 0.5
        if let data = recordingData {
            do{
                
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer.delegate = self
            if audioPlayer.prepareToPlay() {
            print ("開始播放")
            audioPlayer.play()
         }
            } catch let error {
                print (error)
            }
        
        }
    }
    
    
    
}


extension RecordingDetailViewController : AVAudioPlayerDelegate , UITextFieldDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        PlayButton.isEnabled = true
        PlayButton.alpha = 1
        print ("播放結束")
    }
    
    func fetchRecordingData(completion : @escaping (Data) -> ()) {
        if let url = recording?.recordingUrl, let audioFilename = URL(string:url) {
            URLSession.shared.dataTask(with: audioFilename) { (data, response, error) in
                if error != nil {
                    print (error)
                }
                if let recordingData = data {
                    DispatchQueue.main.async {
                        completion(recordingData)
                    }
                }
        }.resume()
    }
    
  }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


