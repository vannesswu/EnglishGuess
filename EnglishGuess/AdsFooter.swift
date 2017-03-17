//
//  adsFooter.swift
//  EnglishGuess
//
//  Created by 吳建豪 on 2017/3/15.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import  LBTAComponents

class AdsFooter: UITableViewHeaderFooterView {
    
    var bannerView:GADBannerView! {
        didSet {
            self.addSubview(bannerView)
            self.bannerView.fillSuperview()
            
        }
    }
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

