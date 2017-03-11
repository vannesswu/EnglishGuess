//
//  EnglishGuessVIP.swift
//  EnglishGuess
//
//  Created by 吳建豪 on 2017/3/9.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation


public struct EnglishGuessVIP {
    
    static let share = EnglishGuessVIP()
    let productID = "ios.swift.VIP"
    
  //  let productIdentifiers: Set<ProductIdentifier> = [productID]
    
    let store = IAPHelper(productIds: ["ios.swift.VIP"])
}


