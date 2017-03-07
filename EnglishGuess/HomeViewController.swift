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

class HomeViewController: UIViewController {

    var user:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        let backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        backBarButtonItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: .normal)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationItem.backBarButtonItem = backBarButtonItem
        checkIfUserIsLoggedIn()
    }

    override func viewWillLayoutSubviews() {
        setupStatusView()
        setupCategoryView()
        setupTitleImageView()
    }
    
    
    lazy var questionSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["我要練聽力", "我要練口說"])
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    
    var CompletedQuestions = 0
    var uploadQuestions = 0
    let statusView = UIView()
    func setupStatusView() {
        
        let todayCompletedQuestionLabel:UILabel = {
            let label1 = UILabel()
            label1.textAlignment = .center
            label1.textColor = UIColor.white
            return label1
        }()
        let uploadQuestionLabel:UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = UIColor.white
            return label
        }()

        
        
        statusView.backgroundColor = UIColor.mainBlue
        view.addSubview(statusView)
        statusView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 100)
        statusView.addSubview(todayCompletedQuestionLabel)
        statusView.addSubview(uploadQuestionLabel)
        todayCompletedQuestionLabel.anchor(statusView.topAnchor, left: statusView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.size.width/2, heightConstant: 50)
        uploadQuestionLabel.anchor(todayCompletedQuestionLabel.topAnchor, left: todayCompletedQuestionLabel.rightAnchor, bottom: nil, right: statusView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        todayCompletedQuestionLabel.text = "今日已答題數:\(CompletedQuestions)/10"
        uploadQuestionLabel.text = "已上傳題數:\(uploadQuestions)/10"
        
        statusView.addSubview(questionSegmentedControl)
        questionSegmentedControl.anchor(todayCompletedQuestionLabel.bottomAnchor, left: statusView.leftAnchor, bottom: statusView.bottomAnchor, right: statusView.rightAnchor, topConstant: 15, leftConstant: 50, bottomConstant: 5, rightConstant: 50, widthConstant: 0, heightConstant: 0)
        
    }
    
    lazy var cat1Button = UIButton.makeCatButton(title: "Cat 1")
    lazy var cat2Button = UIButton.makeCatButton(title: "Cat 2")
    lazy var cat3Button = UIButton.makeCatButton(title: "Cat 3")
    lazy var cat4Button = UIButton.makeCatButton(title: "Cat 4")
    lazy var cat5Button = UIButton.makeCatButton(title: "Cat 5")
    lazy var cat6Button = UIButton.makeCatButton(title: "Cat 6")
    
    func handleCatButtonPress(_ sender:UIButton){
        
        if questionSegmentedControl.selectedSegmentIndex == 1 {
            let recordViewController = RecordViewController()
            recordViewController.category = sender.currentTitle
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
        
        cat3Button.anchorCenterYToSuperview()
        cat3Button.anchor(nil, left: categoryView.leftAnchor, bottom: nil, right: categoryView.centerXAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 6, widthConstant: 0, heightConstant: 80)
        cat4Button.anchorCenterYToSuperview()
        cat4Button.anchor(cat3Button.topAnchor, left: categoryView.centerXAnchor, bottom: nil, right: categoryView.rightAnchor, topConstant: 0, leftConstant: 6, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 80)
        cat1Button.anchor(nil, left: cat3Button.leftAnchor, bottom: cat3Button.topAnchor, right: cat3Button.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 12, rightConstant: 0, widthConstant: 0, heightConstant: 80)
        cat2Button.anchor(nil, left: cat4Button.leftAnchor, bottom: cat4Button.topAnchor, right: cat4Button.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 12, rightConstant: 0, widthConstant: 0, heightConstant: 80)
        
        cat5Button.anchor(cat3Button.bottomAnchor, left: cat3Button.leftAnchor, bottom: nil, right: cat3Button.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 80)
        cat6Button.anchor(cat4Button.bottomAnchor, left: cat4Button.leftAnchor, bottom: nil, right: cat4Button.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 80)
        
    }
    
    
    func setupTitleImageView() {
        
        let titleImageView = UIImageView()
        titleImageView.image = #imageLiteral(resourceName: "英文猜猜樂").withRenderingMode(.alwaysTemplate)
        titleImageView.tintColor = UIColor.titleViewCyan
        titleImageView.contentMode = .scaleAspectFill
        view.addSubview(titleImageView)
        titleImageView.anchor(statusView.bottomAnchor, left: view.leftAnchor, bottom: cat1Button.topAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }
    

    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.user = User(dictionary:dictionary)
                self.setupNavBarTitle(self.user)
            }
            
        }, withCancel: nil)
    }

    func setupNavBarTitle(_ user:User) {
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        //        titleView.backgroundColor = UIColor.redColor()
        
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
       
        nameLabel.anchor(nil, left: profileImageView.rightAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        nameLabel.anchorCenterYToSuperview()

        containerView.anchorCenterSuperview()
        self.navigationItem.titleView = titleView
        
    }
    
    func handleLogout() {
        
        do {
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


}


