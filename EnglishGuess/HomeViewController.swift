//
//  ViewController.swift
//  EnglishGuess
//
//  Created by 吳建豪 on 2017/3/6.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import UIKit
import Firebase
import LBTAComponents
import FBSDKLoginKit
import StoreKit
class HomeViewController: UIViewController {

    var user:User!
    lazy var menuLauncher: MenuLauncher = {
        let launcher = MenuLauncher()
        return launcher
    }()
    
    var products = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupBarButton()
        checkIfUserIsLoggedIn()
    }
    
    func setupBarButton() {
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        let backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        backBarButtonItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: .normal)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.backBarButtonItem = backBarButtonItem
        
        
        let settingImage = UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: settingImage, style: .plain, target: self, action: #selector(handleSetting))
        navigationItem.rightBarButtonItems = [searchBarButtonItem]
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.handlePurchaseNotification),
            name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),object: nil)

    }
    func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        
        for (_, product) in products.enumerated() {
            guard product.productIdentifier == productID else { continue }
            
        }
    }
    func handleSetting() {
        menuLauncher.homeViewController = self
        menuLauncher.products = products
        menuLauncher.showMenuLauncher()
    }
    override func viewWillLayoutSubviews() {
        setupStatusView()
        setupCategoryView()
        setupTitleImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateLabelCount()
        checkVIP()
    }
    
    func checkVIP(){
        products = []
        EnglishGuessVIP.share.store.requestProducts{success, products in
        if success {
                self.products = products!
            }
        }
    }
    
    
    func updateLabelCount() {
        todayCompletedQuestionLabel.update()
        uploadQuestionLabel.update()
    }
    
    
    lazy var questionSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["我要練聽力", "我要練口說"])
        sc.changeTitleFont(newFontName: "HelveticaNeue-Bold", newFontSize: 16)
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    
    var CompletedQuestions = 0
    var uploadQuestions = 0
    let statusView = UIView()
    
    let todayCompletedQuestionLabel = TodayCompletedQuestionLabel()
    let uploadQuestionLabel = UploadQuestionLabel()
    func setupStatusView() {
        todayCompletedQuestionLabel.delegateController = self
        statusView.backgroundColor = UIColor.mainBlue
        view.addSubview(statusView)
        statusView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 100)
        statusView.addSubview(todayCompletedQuestionLabel)
        statusView.addSubview(uploadQuestionLabel)
        todayCompletedQuestionLabel.anchor(statusView.topAnchor, left: statusView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.size.width/2, heightConstant: 50)
        uploadQuestionLabel.anchor(todayCompletedQuestionLabel.topAnchor, left: todayCompletedQuestionLabel.rightAnchor, bottom: nil, right: statusView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        
        statusView.addSubview(questionSegmentedControl)
        questionSegmentedControl.anchor(todayCompletedQuestionLabel.bottomAnchor, left: statusView.leftAnchor, bottom: statusView.bottomAnchor, right: statusView.rightAnchor, topConstant: 15, leftConstant: 50, bottomConstant: 5, rightConstant: 50, widthConstant: 0, heightConstant: 0)
        
    }
    
    lazy var cat1Button = UIButton.makeCatButton(title: "食物類")
    lazy var cat2Button = UIButton.makeCatButton(title: "抽象類")
    lazy var cat3Button = UIButton.makeCatButton(title: "生活類")
    lazy var cat4Button = UIButton.makeCatButton(title: "自然類")
    lazy var cat5Button = UIButton.makeCatButton(title: "人物類")
    lazy var cat6Button = UIButton.makeCatButton(title: "進階類")
    
    func handleCatButtonPress(_ sender:UIButton){
        
        if questionSegmentedControl.selectedSegmentIndex == 1 {
            let recordViewController = RecordViewController()
            recordViewController.category = sender.currentTitle
            let topics = Topic.share.returnTopicBy(sender.currentTitle!)
            recordViewController.engTopicAry = Array(topics.values)
            recordViewController.chineseTopicAry = Array(topics.keys)
            recordViewController.user = user
            navigationController?.pushViewController(recordViewController, animated: true)
        } else {
            let questionViewController = QuestionViewController()
            questionViewController.category = sender.currentTitle!
            navigationController?.pushViewController(questionViewController, animated: true)
            
            
        }
        
    }
    
    func setupCategoryView() {
        let categoryView = UIView()
        view.addSubview(categoryView)
        categoryView.anchor(statusView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        categoryView.addSubview(cat1Button)
        categoryView.addSubview(cat2Button)
        categoryView.addSubview(cat3Button)
        categoryView.addSubview(cat4Button)
        categoryView.addSubview(cat5Button)
        categoryView.addSubview(cat6Button)
        
        let btnWidth = view.frame.size.width/3.5
        cat3Button.anchorCenterYToSuperview()
        cat3Button.anchor(nil, left: nil, bottom: nil, right: categoryView.centerXAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 2.5, widthConstant: btnWidth, heightConstant: btnWidth)
        cat4Button.anchorCenterYToSuperview()
        cat4Button.anchor(cat3Button.topAnchor, left: categoryView.centerXAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 2.5, bottomConstant: 0, rightConstant: 5, widthConstant: btnWidth, heightConstant: btnWidth)
        cat1Button.anchor(nil, left: cat3Button.leftAnchor, bottom: cat3Button.topAnchor, right: cat3Button.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: btnWidth)
        cat2Button.anchor(nil, left: cat4Button.leftAnchor, bottom: cat4Button.topAnchor, right: cat4Button.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: btnWidth)
        
        cat5Button.anchor(cat3Button.bottomAnchor, left: cat3Button.leftAnchor, bottom: nil, right: cat3Button.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: btnWidth)
        cat6Button.anchor(cat4Button.bottomAnchor, left: cat4Button.leftAnchor, bottom: nil, right: cat4Button.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: btnWidth)
        
    }
    
    
    func setupTitleImageView() {
        
        let titleImageView = UIImageView()
        titleImageView.image = #imageLiteral(resourceName: "你說我猜").withRenderingMode(.alwaysTemplate)
        titleImageView.tintColor = UIColor.titleViewCyan
        titleImageView.contentMode = .scaleAspectFit
        view.addSubview(titleImageView)
        titleImageView.anchor(statusView.bottomAnchor, left: view.leftAnchor, bottom: cat1Button.topAnchor, right: view.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 5, rightConstant: 5, widthConstant: 0, heightConstant: 0)
        
    }
    

    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    var UserID:String = ""
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        UserID = uid
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.user = User(dictionary:dictionary)
                self.setupNavBarTitle(self.user)
                
            }
            let numberOfUpload = self.user.recordings?.count ?? 0
            UserDefaults.standard.set(numberOfUpload, forKey: uid+"EnglishGuessUpload")
            self.updateLabelCount()
            
        }, withCancel: nil)
    }
    let titleLabel = UILabel()
    func setupNavBarTitle(_ user:User) {
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        //        titleView.backgroundColor = UIColor.redColor()
        if let title = user.title {
        settingUserQuota(title)
            titleLabel.text = title
        }
        let containerView = UIView()
        titleView.addSubview(containerView)
        
        let profileImageView = CachedImageView()
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImage(urlString: profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.anchor(nil, left: containerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        profileImageView.anchorCenterYToSuperview()
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        nameLabel.textColor = UIColor.white
        nameLabel.text = user.name ?? ""
        nameLabel.adjustsFontSizeToFitWidth = true
       
        nameLabel.anchor(nil, left: profileImageView.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 40)
        nameLabel.anchorCenterYToSuperview()
        
        containerView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.white
        titleLabel.anchor(nil, left: nameLabel.rightAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        titleLabel.anchorCenterYToSuperview()
        
        containerView.anchorCenterSuperview()
        self.navigationItem.titleView = titleView
        
    }
    
    func settingUserQuota(_ title:String) {
        
        if title == "一般會員" {
            UserDefaults.standard.set(10, forKey: "\(UserID)userUploadQuota")
            UserDefaults.standard.set(10, forKey: "\(UserID)userAnswerQuotaForJudge")
            UserDefaults.standard.set("10", forKey: "\(UserID)userAnswerQuota")
        } else {
            UserDefaults.standard.set(100, forKey: "\(UserID)userUploadQuota")
            UserDefaults.standard.set(9999, forKey: "\(UserID)userAnswerQuotaForJudge")
            UserDefaults.standard.set("不限", forKey: "\(UserID)userAnswerQuota")
            
        }
        
    }
    
    func handleLogout() {
        
        do {
            FBSDKLoginManager().logOut()
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        DispatchQueue.main.async {
            let vc = LoginViewController()
            vc.homeViewController = self
            self.present(vc, animated: true, completion: nil)
            print ("here")
        }
    }
   
    func showUserUploadFiles() {
        let userFilesVC = UserFilesViewController()
        navigationController?.pushViewController(userFilesVC, animated: true)
        
        
    }

}


