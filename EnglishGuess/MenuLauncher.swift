//
//  menuLauncher.swift
//  EnglishGuess
//
//  Created by 吳建豪 on 2017/3/8.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import UIKit
import LBTAComponents
import Firebase
import StoreKit

class MenuLauncher :NSObject {
    
    var products = [SKProduct]()
    var homeViewController:HomeViewController?
    override init() {
        super.init()
    }

    
    
    let blackView = UIView()
    let menuView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainBlue
        return view
    }()
    func showMenuLauncher() {
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(blackView)
            window.addSubview(menuView)
            setupHeaderView()
            setupLogoutButton()
            setupUploadFiles()
            setupUpdateVIP()
            menuView.frame = CGRect(x: window.frame.width, y: 0, width: window.frame.width/2, height: window.frame.height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
                self.menuView.frame = CGRect(x: window.frame.width/2, y: 0, width: self.menuView.frame.width, height: self.menuView.frame.height)
                
            }, completion: nil)
        }
        
    }
    func setupHeaderView() {
        menuView.addSubview(headerView)
        headerView.anchor(menuView.topAnchor, left: menuView.leftAnchor, bottom: nil, right: menuView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 44+20+100)
        let statusBarBackgroundView = UIView()
        statusBarBackgroundView.backgroundColor = UIColor.darkBlue
        menuView.addSubview(statusBarBackgroundView)
        statusBarBackgroundView.anchor(menuView.topAnchor, left: menuView.leftAnchor, bottom: nil, right: menuView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        let titleLabel = UILabel()
        titleLabel.text = "用戶設定"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textColor = UIColor.white
        headerView.addSubview(titleLabel)
        titleLabel.anchorCenterXToSuperview()
        titleLabel.anchorCenterYToSuperview()
        
        
    }
    lazy var userLogoutButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("用戶登出", for: .normal)
        btn.setTitleColor(UIColor.darkText, for: .normal)
        btn.addTarget(self, action: #selector(userLogout), for: .touchUpInside)
        return btn
    }()
    let logoutSepareView = UIView.makeSeparatorView()
    let logoutImageView:UIImageView = {
          let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "logout").withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.darkGray
          iv.contentMode = .scaleAspectFit
          return iv
    }()
    func setupLogoutButton() {
        menuView.addSubview(userLogoutButton)
        menuView.addSubview(logoutSepareView)
        menuView.addSubview(logoutImageView)
        logoutImageView.anchor(headerView.bottomAnchor, left: menuView.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        userLogoutButton.anchor(headerView.bottomAnchor, left: logoutImageView.rightAnchor, bottom: nil, right: menuView.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 50)
        logoutSepareView.anchor(nil, left: menuView.leftAnchor, bottom: userLogoutButton.bottomAnchor, right: menuView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
    func userLogout() {
        handleDismiss()
        homeViewController?.handleLogout()
    }
    lazy var userUploadfilesButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("檢視上傳", for: .normal)
        btn.setTitleColor(UIColor.darkText, for: .normal)
        btn.addTarget(self, action: #selector(checkUserUploadFiles), for: .touchUpInside)
        return btn
    }()
    let uploadfilesSepareView = UIView.makeSeparatorView()
    let uploadfilesImageView:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "folder").withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.darkGray
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    func setupUploadFiles() {
        menuView.addSubview(userUploadfilesButton)
        menuView.addSubview(uploadfilesSepareView)
        menuView.addSubview(uploadfilesImageView)
        uploadfilesImageView.anchor(userLogoutButton.bottomAnchor, left: menuView.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        userUploadfilesButton.anchor(userLogoutButton.bottomAnchor, left: uploadfilesImageView.rightAnchor, bottom: nil, right: menuView.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 50)
        uploadfilesSepareView.anchor(nil, left: menuView.leftAnchor, bottom: userUploadfilesButton.bottomAnchor, right: menuView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
    
    func checkUserUploadFiles() {
        handleDismiss()
        homeViewController?.showUserUploadFiles()
    }
    
    lazy var userUpdateVIPButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("升級VIP", for: .normal)
        btn.setTitleColor(UIColor.darkText, for: .normal)
        btn.addTarget(self, action: #selector(updateVIP), for: .touchUpInside)
        return btn
    }()
    let UpdateVIPSepareView = UIView.makeSeparatorView()
    let UpdateVIPImageView:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "vip").withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.darkGray
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    func setupUpdateVIP() {
        menuView.addSubview(userUpdateVIPButton)
        menuView.addSubview(UpdateVIPSepareView)
        menuView.addSubview(UpdateVIPImageView)
        UpdateVIPImageView.anchor(userUploadfilesButton.bottomAnchor, left: menuView.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        userUpdateVIPButton.anchor(userUploadfilesButton.bottomAnchor, left: UpdateVIPImageView.rightAnchor, bottom: nil, right: menuView.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 50)
        UpdateVIPSepareView.anchor(nil, left: menuView.leftAnchor, bottom: userUpdateVIPButton.bottomAnchor, right: menuView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        
    }
    
    func updateVIP() {
        handleDismiss()
        homeViewController?.updateVIP()
    }
    
    
    func handleDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.menuView.frame = CGRect(x: window.frame.width, y: 0, width: self.menuView  .frame.width, height: self.menuView.frame.height)
            }
            
        }) { (completed: Bool) in }
        
    }

}
