//
//  LoginViewController.swift
//  EnglishGuess
//
//  Created by 吳建豪 on 2017/3/6.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import Firebase
import LBTAComponents

enum registerMethod {
    case email
    case fb
    
}

class LoginViewController:UIViewController ,FBSDKLoginButtonDelegate {
    
    
    var homeViewController: HomeViewController?
    lazy var isUserConfirmAlert:UIAlertController = {
        let at = UIAlertController(title: "您尚未勾選用戶協議", message: "請先閱讀用戶協議並選取確認", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        at.addAction(okAction)
        return at
    }()
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var userAgreement:UserAgreement = {
        return UserAgreement()
    }()
    
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.htmlBlue
        button.setTitle("註冊", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    lazy var fbLoginButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("使用FaceBook帳號登入", for: .normal)
        btn.backgroundColor = UIColor.htmlBlue
        btn.addTarget(self, action: #selector(customFBLogin), for: .touchUpInside)
        return btn
    }()
    lazy var  loginButton :FBSDKButton = {
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        return loginButton
    }()
    
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            if !isUserConfirm {
                self.present(isUserConfirmAlert, animated: true, completion: nil)
                return
            }
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        handleUserLogin()
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error ?? "")
                self.blackView.removeFromSuperview()
                let alertController = UIAlertController(title: "Oop 出錯了", message: error?.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            //successfully logged in our user
            
            self.homeViewController?.fetchUserAndSetupNavBarTitle()
            self.transitionAnimate()
       //     self.dismiss(animated: false, completion: nil)
            
        })
        
    }
    func handleRegister() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }

        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                let alertController = UIAlertController(title: "Oop 出錯了", message: error?.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                print(error ?? "")
                return
            }
            self.handleUserLogin()
            self.handleProfileImage(registerMethod.email)
       })
    }
    
    fileprivate func handleProfileImage(_ method : registerMethod) {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        var email:String = ""
        var name:String = ""
        
        switch method {
        case .email:
            guard let userEmail = emailTextField.text,let userName = nameTextField.text else {
                print("Form is not valid")
                return
            }
            email = userEmail
            name = userName
        case .fb:
            guard let userEmail = fbUserDict?["email"] as? String, let userName = fbUserDict?["name"] as? String else {
                print("Form is not valid")
                return
            }
            email = userEmail
            name = userName
            
        }
        //successfully authenticated user
        let imageName = UUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    
                    let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl,"title":"一般會員"]
                    
                    self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                }
            })
        }
        
    }
    
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err ?? "")
                return
            }
            
            self.homeViewController?.fetchUserAndSetupNavBarTitle()
            self.transitionAnimate()
     //       self.dismiss(animated: false, completion: nil)
            

        })
    }
    
    let blackView = UIView()
    let spinner = UIActivityIndicatorView()
    let handlingLabel = UILabel()
    func handleUserLogin() {
        
        if let window = UIApplication.shared.keyWindow {
            
            window.addSubview(blackView)
            blackView.fillSuperview()
            blackView.backgroundColor = UIColor.mainBlue
            blackView.addSubview(spinner)
            blackView.addSubview(handlingLabel)
            handlingLabel.anchorCenterSuperview()
            spinner.anchorCenterYToSuperview()
            spinner.activityIndicatorViewStyle = .gray
            spinner.anchor(nil, left: handlingLabel.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
            //   handlingLabel.backgroundColor = UIColor.white
            handlingLabel.font = UIFont.systemFont(ofSize: 25)
            handlingLabel.text = "用戶登入中請稍候"
            handlingLabel.textColor = UIColor.white
            spinner.startAnimating()
            let titleImgeView = UIImageView()
            titleImgeView.image = #imageLiteral(resourceName: "你說我猜").withRenderingMode(.alwaysTemplate)
            titleImgeView.tintColor = UIColor.white
            titleImgeView.contentMode = .scaleAspectFit
            blackView.addSubview(titleImgeView)
            titleImgeView.anchor(blackView.topAnchor, left: blackView.leftAnchor, bottom: nil, right: blackView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: window.frame.height/3)
        }
    }
    func transitionAnimate() {
       
        if let window = UIApplication.shared.keyWindow {
         UIView.animate(withDuration: 0.5, animations: {
            self.blackView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height)
            
         }, completion: { (_) in
            self.blackView.removeFromSuperview()
            self.dismiss(animated: true, completion: nil)
     //       self.blackView.removeFromSuperview()

         })
            
      }
    }
    lazy var profileImageView:CachedImageView = {
        let iv = CachedImageView()
        iv.image = UIImage(named: "defaultprofile")
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectorProfileImageView)))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    func handleSelectorProfileImageView(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["登入", "註冊"])
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: UIControlState())
        
        // change height of inputContainerView, but how???
        nameTextField.isHidden =  loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
    
    }
    
    lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "使用者名稱"
        tf.delegate = self
        return tf
    }()
    
    let nameSeparatorView = UIView.makeSeparatorView()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "信箱"
        tf.delegate = self
        return tf
    }()
    
    let emailSeparatorView = UIView.makeSeparatorView()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "密碼(至少六個字元)"
        tf.delegate = self
        tf.isSecureTextEntry = true
        return tf
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainBlue
    
    }
    
    override func viewWillLayoutSubviews() {
        setupInputsContainerView()
        setupLoginRegisterSegmentedControl()
        setupProfileImageView()
        setupUserAgreementView()
        setupLoginRegisterButton()
        setupFBLoginButton()
        
    }
    let tipLabel:UILabel = {
        let label = UILabel()
        label.text = "點擊圖示更換頭像或FB登入沿用大頭照"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
        
    func setupProfileImageView() {
        view.addSubview(profileImageView)
        view.addSubview(tipLabel)
        profileImageView.anchorCenterXToSuperview()
        profileImageView.anchor(nil, left: nil, bottom: loginRegisterSegmentedControl.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 12, rightConstant: 0, widthConstant: 100, heightConstant: 100)
        tipLabel.anchorCenterXToSuperview()
        tipLabel.anchor(nil, left: nil, bottom: profileImageView.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 250, heightConstant: 20)
        
    }
    
    func setupLoginRegisterSegmentedControl() {
        view.addSubview(loginRegisterSegmentedControl)
        loginRegisterSegmentedControl.anchor(nil, left: inputsContainerView.leftAnchor, bottom: inputsContainerView.topAnchor, right: inputsContainerView.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 12, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        loginRegisterSegmentedControl.anchorCenterXToSuperview()
        
        
    }
    func setupInputsContainerView(){
        view.addSubview(inputsContainerView)
        inputsContainerView.anchorCenterSuperview()
        inputsContainerView.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 300, heightConstant: 150)
        inputsContainerView.addSubview(nameTextField)
        emailTextField.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        emailTextField.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        nameTextField.anchor(inputsContainerView.topAnchor, left: inputsContainerView.leftAnchor, bottom: nil, right: inputsContainerView.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        nameSeparatorView.anchor(emailTextField.topAnchor, left: inputsContainerView.leftAnchor, bottom: nil, right: inputsContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        emailTextField.anchor(nameTextField.bottomAnchor, left: nameTextField.leftAnchor, bottom: nil, right: nameTextField.rightAnchor , topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        emailSeparatorView.anchor(nil, left: inputsContainerView.leftAnchor, bottom: emailTextField.bottomAnchor, right: inputsContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        passwordTextField.anchor(emailTextField.bottomAnchor, left: nameTextField.leftAnchor, bottom: inputsContainerView.bottomAnchor, right: nameTextField.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
    }
    
    var isUserConfirm = false
    lazy var checkImageView:UIImageView = {
        let iv = UIImageView()
        iv.layer.borderWidth = 4
        iv.layer.borderColor = UIColor.black.cgColor
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeImage)))
        return iv
    }()
    var prefixLabel:UILabel = {
        let label = UILabel()
        label.text = "我已閱讀並同意"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    lazy var userAgreementButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("<<用戶協議>>", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(self, action: #selector(showuserAgreement), for: .touchUpInside)
        return btn
    }()
    
    func setupUserAgreementView(){
        view.addSubview(checkImageView)
        view.addSubview(prefixLabel)
        view.addSubview(userAgreementButton)
        checkImageView.anchor(inputsContainerView.bottomAnchor, left: inputsContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 20)
        prefixLabel.anchor(checkImageView.topAnchor, left: checkImageView.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 20)
        userAgreementButton.anchor(checkImageView.topAnchor, left: prefixLabel.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 20)
        
    }
    func showuserAgreement() {
        present(userAgreement, animated: true, completion: nil)
    }
    func changeImage(){
        isUserConfirm = !isUserConfirm
        checkImageView.image = isUserConfirm ?  #imageLiteral(resourceName: "check") : nil
      
    }
    
    func setupLoginRegisterButton() {
        view.addSubview(loginRegisterButton)
        loginRegisterButton.anchor(checkImageView.bottomAnchor, left: inputsContainerView.leftAnchor, bottom: nil, right: inputsContainerView.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        loginRegisterButton.anchorCenterXToSuperview()
        
    }
    
    func setupFBLoginButton() {
        view.addSubview(fbLoginButton)
        fbLoginButton.anchor(loginRegisterButton.bottomAnchor, left: loginRegisterButton.leftAnchor, bottom: nil, right: loginRegisterButton.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result:
        FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        handleFBLogin()
    }
    
    func customFBLogin() {
        if !isUserConfirm {
            self.present(isUserConfirmAlert, animated: true, completion: nil)
            return
        }
        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: self) { (result, error) in
            if error != nil || !(result?.grantedPermissions?.contains("email") ?? false) {
                let alertController = UIAlertController(title: "Oop 出錯了", message: "\(error?.localizedDescription ?? "") or 請確認email授權", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                print(error ?? "")

                print("Custom FB Login failed:", error ?? "")
                return
            }
            self.handleFBLogin()
        }
    }
    var fbUserDict:[String:AnyObject]?
    func handleFBLogin() {
  
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        self.handleUserLogin()
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
            
                print("Something went wrong with our FB user: ", error ?? "")
                return
            }
            
            print("Successfully logged in with our user: ", user ?? "")
            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
                
                if err != nil {
                    print("Failed to start graph request:", err ?? "")
                    return
                }
                print(result ?? "")
                
                self.fbUserDict = result as? [String:AnyObject]
                if let fid = self.fbUserDict?["id"] as? String {
                    let urlString = "http://graph.facebook.com/\(fid)/picture?type=large"
                    self.profileImageView.loadImage(urlString: urlString, completion: {
                        self.handleProfileImage(.fb)
                    })
                }
            }
        })
    }
}

extension LoginViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
}

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
