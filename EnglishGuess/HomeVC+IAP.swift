//
//  HomeVC+IAP.swift
//  EnglishGuess
//
//  Created by 吳建豪 on 2017/3/10.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import UIKit
import LBTAComponents
import StoreKit
import Firebase


extension HomeViewController {
    
    func updateVIP(){
        
        let priceFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            
            formatter.formatterBehavior = .behavior10_4
            formatter.numberStyle = .currency
            
            return formatter
        }()

        
        
        guard let product = products.first else { return }
        
        if IAPHelper.canMakePayments() {
            priceFormatter.locale = product.priceLocale
            if let price = priceFormatter.string(from: product.price) {

        let alertController = UIAlertController(title: "\(product.localizedTitle)  \(price)", message: "\(product.localizedDescription)", preferredStyle: .alert)
       
        let okAction = UIAlertAction(title: "確定購買", style: UIAlertActionStyle.default) { (action) in
            EnglishGuessVIP.share.store.homeViewController = self
            EnglishGuessVIP.share.store.buyProduct(product)
        }
        let restoreAction = UIAlertAction(title: "恢復購買", style: UIAlertActionStyle.default) { (action) in
            EnglishGuessVIP.share.store.homeViewController = self
            EnglishGuessVIP.share.store.restorePurchases()
        }
        
                
                
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        alertController.addAction(restoreAction)
        present(alertController, animated: true, completion: nil)
            }
     }
    }
    
}



