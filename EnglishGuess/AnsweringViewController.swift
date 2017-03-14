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
import Firebase
import AVFoundation

class AnsweringViewController:UIViewController {
    
    var categoary:String?
    var recording:Recording?
    var key:String?
    var audioPlayer:AVAudioPlayer!
    var recordingSession: AVAudioSession!
    var recordingData:Data?
    var isNeedAddHeight = true
    var isLike = false
    var isDislike = false
    var recordRef: FIRDatabaseReference?
    var recordings = [Recording]()
    var numberOfQ:Int = {
        return UserDefaults.numberOfQInToday()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = recording?.id ,let categoary = self.categoary {
        recordRef = FIRDatabase.database().reference().child("users-recordings").child(categoary).child(id)
        }
        view.backgroundColor = UIColor.white
        recordingSession = AVAudioSession.sharedInstance()
        do {
            //     try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with:.defaultToSpeaker)
            try recordingSession.setActive(true)
        } catch {
            // failed to record!
        }
        
        
        let changeTopicBarButtonItem = UIBarButtonItem(title: "換一題", style: .plain, target: self, action: #selector(chooseRandomRecording))
        navigationItem.rightBarButtonItems = [changeTopicBarButtonItem]
        let backImage = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
        let backBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItems = [backBarButtonItem]
        
        
        showhandlingupload()
        fetchRecordingData { (data) in
            self.blackView.removeFromSuperview()
            self.recordingData = data
            self.setupTopicView()
            self.setupViews()
            self.setupProviderView()

        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(AnsweringViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AnsweringViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func dismissVC() {
        if checkUserIsAnswer {
            present(remindUserAnswerAlert, animated: true, completion: nil)
            return
        }
        resultView.removeFromSuperview()
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    func chooseRandomRecording() {
        
        if checkUserIsAnswer {
            present(remindUserAnswerAlert, animated: true, completion: nil)
            return
        
        }
        
        if UserDefaults.numberOfQInToday() < UserDefaults.userAnswerQuotaForJudge() {
            let randomIndex = Int(arc4random_uniform(UInt32(recordings.count)))
            anserTextField.text = ""
            anserTextField.isEnabled = true
            checkAnswerButton.isEnabled = true
            checkAnswerButton.alpha = 1
            showhandlingupload()
            recording = recordings[randomIndex]
            if let id = recording?.id ,let categoary = self.categoary {
                recordRef = FIRDatabase.database().reference().child("users-recordings").child(categoary).child(id)
            }
            
            
            fetchRecordingData { (data) in
                self.blackView.removeFromSuperview()
                self.recordingData = data
                self.topicLabel.text = "答案為: ?? "
                self.updateProviderInfo()
            }
        } else {
            let alertController = UIAlertController(title: "今日答題錯誤次數已滿", message: "點擊廣告回復次數", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
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
//            let userInfo = notification.userInfo ?? [:]
//            let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            let adjustmentHeight:CGFloat = 100  * (show ? 1 : -1)
            
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -adjustmentHeight)
            isNeedAddHeight = false
        }
    }
    
    let titleView = UIView()
    let numberOfQLabel = TodayCompletedQuestionLabel()
    override func viewWillLayoutSubviews() {
        setupTitleView()
    }
    func setupTitleView() {
        let titleView = UIView()
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playad)))
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        let containerView = UIView()
        titleView.addSubview(containerView)
        containerView.addSubview(numberOfQLabel)
        numberOfQLabel.anchorCenterSuperview()
        numberOfQLabel.delegateController = self
        containerView.anchorCenterSuperview()
        navigationItem.titleView = titleView
    }
    func playad() {
        numberOfQLabel.playVideo()
           }
    override func viewWillAppear(_ animated: Bool) {
        numberOfQLabel.update()
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
            handlingLabel.text = "資料處理中請稍候"
            spinner.startAnimating()
        }
    }
    
    
    let topicLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textAlignment = .center
        label.backgroundColor = UIColor.lightGray
        label.numberOfLines = 0
        return label
    }()
    
    func setupTopicView () {
        view.addSubview(topicLabel)
        topicLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.size.height/4)
        topicLabel.text = "答案為: ?? "
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
        btn.backgroundColor = UIColor.darkBlue
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
    lazy var providerLabel: UILabel = {
        let label = UILabel()
        label.text = self.recording?.userName ?? ""
        return label
    }()
    lazy var providerProfileImageView:CachedImageView = {
        let iv = CachedImageView()
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        if let url = self.recording?.profileImageUrl {
        iv.loadImage(urlString: url)
        }
        return iv
    }()
    lazy var likeButton:UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        btn.addTarget(self , action: #selector(upadteLikes), for: .touchUpInside)
        return btn
    }()
    lazy var dislikeButton:UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "dislike"), for: .normal)
        btn.addTarget(self , action: #selector(upadteDislikes), for: .touchUpInside)
        return btn
    }()
    lazy var  likeLabel:UILabel = {
        let label = UILabel()
        label.text = "\(self.recording?.likes ?? 0 )"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    lazy var  dislikeLabel:UILabel = {
        let label = UILabel()
        label.text = "\(self.recording?.dislikes ?? 0 )"
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    func updateProviderInfo(){
        if let url = self.recording?.profileImageUrl {
            providerProfileImageView.loadImage(urlString: url)
        }
        providerLabel.text = self.recording?.userName ?? ""
        likeLabel.text = "\(self.recording?.likes ?? 0 )"
        dislikeLabel.text = "\(self.recording?.dislikes ?? 0 )"
    }
    
    func setupProviderView() {
        view.addSubview(providerLabel)
        view.addSubview(providerProfileImageView)
        view.addSubview(likeButton)
        view.addSubview(dislikeButton)
        view.addSubview(likeLabel)
        view.addSubview(dislikeLabel)
        
        providerProfileImageView.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 5, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        providerLabel.anchor(nil, left: providerProfileImageView.rightAnchor, bottom: providerProfileImageView.bottomAnchor, right: likeButton.leftAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        dislikeLabel.anchor(nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 10, widthConstant: 50, heightConstant: 20)
        dislikeButton.anchor(nil , left: nil, bottom: dislikeLabel.bottomAnchor, right: dislikeLabel.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 5, widthConstant: 25, heightConstant: 25)
        likeLabel.anchor(nil, left: nil, bottom: dislikeLabel.bottomAnchor, right: dislikeButton.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 20)
        likeButton.anchor(nil , left: nil, bottom: dislikeLabel.bottomAnchor, right: likeLabel.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 5, widthConstant: 25, heightConstant: 25)
        
    }
    
    func upadteLikes() {
        
        recordRef?.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = FIRAuth.auth()?.currentUser?.uid {
                var stars : Dictionary<String, Bool>
                stars = post["user_like"] as? [String : Bool] ?? [:]
                var count = post["likes"] as? Int ?? 0
                if let _ = stars[uid] {
                    count -= 1
                    stars.removeValue(forKey: uid)
                } else {
                    count += 1
                    stars[uid] = true
                }
                DispatchQueue.main.async {
                    self.likeLabel.text = "\(count)"
                }
                post["likes"] = count as AnyObject?
                post["user_like"] = stars as AnyObject?
                currentData.value = post
                return FIRTransactionResult.success(withValue: currentData)
            }
            return FIRTransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func upadteDislikes() {
        recordRef?.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = FIRAuth.auth()?.currentUser?.uid {
                var stars : Dictionary<String, Bool>
                stars = post["user_dislike"] as? [String : Bool] ?? [:]
                var count = post["dislikes"] as? Int ?? 0
                if let _ = stars[uid] {
                    count -= 1
                    stars.removeValue(forKey: uid)
                } else {
                    count += 1
                    stars[uid] = true
                }
                DispatchQueue.main.async {
                self.dislikeLabel.text = "\(count)"
                }
                post["dislikes"] = count as AnyObject?
                post["user_dislike"] = stars as AnyObject?
                currentData.value = post
                return FIRTransactionResult.success(withValue: currentData)
            }
            return FIRTransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }

    }
    
    func checkAnswer() {
        
        anserTextField.resignFirstResponder()
        guard let userAnswer = anserTextField.text , userAnswer != "" , let answer = recording?.chAnswer else { return }
        checkUserIsAnswer = false
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        UserDefaults.standard.set(numberOfQ, forKey: uid+Date.returnTodayString())
        numberOfQLabel.update()
        anserTextField.isEnabled = false
        checkAnswerButton.isEnabled = false
        checkAnswerButton.alpha = 0.5
        let isCorrect = userAnswer == answer ? true : false
        if !isCorrect {
        numberOfQ += 1
        UserDefaults.standard.set(numberOfQ, forKey: uid+Date.returnTodayString())
        numberOfQLabel.update()
        }
        animateTheCheckResult(isCorrect)
        if let totalclick = recording?.totalClick, let correct = recording?.correct {
        recording?.totalClick = totalclick + 1
        recording?.correct =  isCorrect ? correct + 1 : correct
        recording?.correctRate = Double((recording?.correct)!)/Double(totalclick + 1)
            if let dict = recording?.returnRecordingDict() {
            recordRef?.updateChildValues(dict, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err ?? "")
                    return
                }
            })
         }
        }
    }
    let resultView = UIImageView()
    func animateTheCheckResult(_ success:Bool) {
        resultView.contentMode = .scaleAspectFit
        resultView.image = success ? #imageLiteral(resourceName: "correct").withRenderingMode(.alwaysTemplate) :#imageLiteral(resourceName: "incorrect").withRenderingMode(.alwaysTemplate)
        resultView.tintColor = success ? UIColor.adoptGreen : UIColor.adoptRed
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(resultView)
            if let PlayButtonFrame = PlayButton.superview?.convert(PlayButton.frame, to: window) {
            resultView.frame = CGRect(x: PlayButtonFrame.origin.x, y: -50, width: PlayButton.frame.width, height: 30)
            
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
                self.resultView.frame = CGRect(x: PlayButtonFrame.origin.x, y: PlayButtonFrame.origin.y - 30, width: self.PlayButton.frame.width, height: 30)
            }, completion: { ( bool:Bool) in
                if bool { DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.resultView.removeFromSuperview()
                    }
                    self.topicLabel.text = "答案為:\(self.recording?.chAnswer ?? "")\n\(self.recording?.engAnswer ?? "")" }
            })
            }
        }
    }
    
    lazy var remindUserAnswerAlert:UIAlertController = {
        let at = UIAlertController(title: "您尚未答題", message: "請輸入答案並選擇確認", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        at.addAction(okAction)
        return at
    }()
    
    var checkUserIsAnswer = false
    
    func playrecording() {
        checkUserIsAnswer = true
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


extension AnsweringViewController : AVAudioPlayerDelegate , UITextFieldDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        PlayButton.isEnabled = true
        PlayButton.alpha = 1
        print ("播放結束")
    }
    
    func fetchRecordingData(completion : @escaping (Data) -> ()) {
        if let url = recording?.recordingUrl, let audioFilename = URL(string:url) {
            URLSession.shared.dataTask(with: audioFilename) { (data, response, error) in
                if error != nil {
                    print (error ?? "")
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


