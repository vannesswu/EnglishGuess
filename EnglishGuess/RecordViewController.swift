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
import AVFoundation


class RecordViewController : UIViewController {
    
    var category:String?
    var user:User!
    override func viewDidLoad() {
        super.viewDidLoad()
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with:.defaultToSpeaker)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print ("sucess")
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
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
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    var audioFilename:URL?
    var uuid = ""
    
    func startRecording() {
        uuid = UUID().uuidString
        audioFilename = getDocumentsDirectory().appendingPathComponent("\(uuid).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.low.rawValue,
            ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename!, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
        } catch {
            finishRecording(success: false)
        }
     startTimer()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func startTimer() {
        countdownTime = 15.0
        countdowntimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(countdownTimer), userInfo: nil, repeats: true)
        buttonEnable(false)
  
        
    }
    func countdownTimer() {
        
        countdownTime -= 0.1
        
          self.timerLabel.text = "\(self.numberFormatter.string(from: NSNumber(value: self.countdownTime))!)"
            if ( self.timerLabel.text == "0.0"){
                self.countdowntimer.invalidate()
                self.buttonEnable(true)
                self.audioRecorder.stop()
        }
        
    }
    
    func uploadRecording() {
        
        showhandlingupload()
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let timeStamp = Int(Date().timeIntervalSince1970)
        let storageRef = FIRStorage.storage().reference().child("recordings").child("\(category ?? "")").child("\(uuid).m4a")
        if let uploadData = try? Data(contentsOf: audioFilename!){
        storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            if let recordingUrl = metadata?.downloadURL()?.absoluteString {
             
                let value = ["recordingID":self.uuid]
                self.updateUserRecordings(uid, values: value as [String : AnyObject])
                let recordValue = ["userName":self.user.name as AnyObject, "profileImageUrl":self.user.profileImageUrl as AnyObject, "category":self.category as AnyObject,"recordingUrl":recordingUrl as AnyObject,"timeStamp":timeStamp as AnyObject,"answer":"吊橋" as AnyObject]
                self.uploadUserRecordings(values: recordValue as [String : AnyObject])

                
            }
         })
        }
    }
    
    fileprivate func updateUserRecordings(_ uid: String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users").child(uid).child("recordings").childByAutoId()
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }
            print("here")
        })
    }
    fileprivate func uploadUserRecordings(values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference()
        guard let cat = category else { return }
        let recordingReference = ref.child("users-recordings").child(cat).child(uuid)
        
        recordingReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }
            self.blackView.removeFromSuperview()
            self.uploadButton.isEnabled = false
            self.uploadButton.alpha = 0.5
            self.playButton.isEnabled = false
            self.playButton.alpha = 0.5
            self.timerLabel.text = "15.0"
            
        })
    }
    
    let blackView = UIView()
    let spinner = UIActivityIndicatorView()
    let handlingLabel = UILabel()
    func showhandlingupload() {
    
        if let window = UIApplication.shared.keyWindow {
        
            window.addSubview(blackView)
            blackView.fillSuperview()
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            blackView.addSubview(spinner)
            blackView.addSubview(handlingLabel)
            handlingLabel.anchorCenterSuperview()
            spinner.anchorCenterYToSuperview()
            spinner.anchor(nil, left: handlingLabel.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
         //   handlingLabel.backgroundColor = UIColor.white
            handlingLabel.font = UIFont.systemFont(ofSize: 25)
            handlingLabel.text = "資料上傳中請稍候"
            spinner.startAnimating()
        }
    }
    
    
    func setupHintView() {
        
        let hintLabel = UILabel()
        hintLabel.numberOfLines = 0
        view.addSubview(hintLabel)
        hintLabel.font = UIFont.systemFont(ofSize: 18)
        hintLabel.textColor = UIColor.init(r: 210, g: 210, b: 210)
        hintLabel.anchor(uploadButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 50, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        hintLabel.text = "溫馨小提示:請不要直接說出題目中英文翻譯裡的任一單字，盡量以英文形容該題目的特色或行為等，時間只有15秒，加油！"
        
    }
    
    func buttonEnable(_ status: Bool){
        if status {
            recordButton.isEnabled = true
            playButton.isEnabled = true
            uploadButton.isEnabled = true
            recordButton.alpha = 1
            playButton.alpha = 1
            uploadButton.alpha = 1
        } else {
            recordButton.isEnabled = false
            playButton.isEnabled = false
            uploadButton.isEnabled = false
            recordButton.alpha = 0.5
            playButton.alpha = 0.5
            uploadButton.alpha = 0.5
        }
        
        
    }
    
}

extension RecordViewController: AVAudioRecorderDelegate ,AVAudioPlayerDelegate {
    
    func playRecording() {
        audioPlayer = try! AVAudioPlayer(contentsOf: audioFilename!)
        audioPlayer.delegate = self
        audioPlayer.volume = 1
        if audioPlayer.prepareToPlay() {
            print ("開始播放")
            audioPlayer.play()
            buttonEnable(false)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
         buttonEnable(true)
        print ("播放結束")
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        } else {
            finishRecording(success: true)
        }
    }
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            
            let filePath = audioFilename?.path
            var fileSize : UInt64
            
            do {
                //return [FileAttributeKey : Any]
                let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath!)
                let fileSizeNumber = fileAttributes[FileAttributeKey.size] as! NSNumber
                let fileSize = fileSizeNumber.int64Value
                var sizeMB = Double(fileSize / 1024)
                sizeMB = Double(sizeMB / 1024)
                print(String(format: "%.2f", sizeMB) + " MB")
            } catch {
                print("Error: \(error)")
            }
            
        } else {
            
            // recording failed :(
        }
    }
}
