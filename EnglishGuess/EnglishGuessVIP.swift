//
//  EnglishGuessVIP.swift
//  EnglishGuess
//
//  Created by 吳建豪 on 2017/3/9.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation


public struct EnglishGuessVIP {
    
    public static let productID = "ios.swift.VIP"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [EnglishGuessVIP.productID]
    
    public static let store = IAPHelper(productIds: EnglishGuessVIP.productIdentifiers)
}


