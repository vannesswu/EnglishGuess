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


class MenuLauncher :NSObject {
    
    
    var homeViewController:HomeViewController?
    override init() {
        super.init()
    }

    
    
    let blackView = UIView()
    let munuView: UIView = {
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
            window.addSubview(munuView)
            setupHeaderView()
            setupLogoutButton()
            
            munuView.frame = CGRect(x: window.frame.width, y: 0, width: window.frame.width/2, height: window.frame.height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
                self.munuView.frame = CGRect(x: window.frame.width/2, y: 0, width: self.munuView.frame.width, height: self.munuView.frame.height)
                
            }, completion: nil)
        }
        
    }
    func setupHeaderView() {
        munuView.addSubview(headerView)
        headerView.anchor(munuView.topAnchor, left: munuView.leftAnchor, bottom: nil, right: munuView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 44+20+100)
        let statusBarBackgroundView = UIView()
        statusBarBackgroundView.backgroundColor = UIColor.darkBlue
        munuView.addSubview(statusBarBackgroundView)
        statusBarBackgroundView.anchor(munuView.topAnchor, left: munuView.leftAnchor, bottom: nil, right: munuView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        let titleLabel = UILabel()
        titleLabel.text = "用戶設定"
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
    
    func setupLogoutButton() {
     munuView.addSubview(userLogoutButton)
        userLogoutButton.anchor(headerView.bottomAnchor, left: munuView.leftAnchor, bottom: nil, right: munuView.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 50)
        
    }
    func userLogout() {
        handleDismiss()
        homeViewController?.handleLogout()
    }
    
    func handleDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.munuView.frame = CGRect(x: window.frame.width, y: 0, width: self.munuView  .frame.width, height: self.munuView.frame.height)
            }
            
        }) { (completed: Bool) in }
        
    }

}
