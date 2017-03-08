//
//  filterHeader.swift
//  EnglishGuess
//
//  Created by 吳建豪 on 2017/3/7.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import UIKit
import LBTAComponents

class FilterHeader: UITableViewHeaderFooterView {
    
    
    var questionController:QuestionViewController?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let backView = UIView()
    lazy var orderSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["依時間排序", "依好評排序","隨機選一題"])
        sc.tintColor = UIColor.white
        sc.backgroundColor = UIColor.mainBlue
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(startOrder), for: .valueChanged)
        return sc
    }()
    
    func setupViews() {
      backView.backgroundColor = UIColor.mainBlue
        addSubview(backView)
        addSubview(orderSegmentedControl)
        backView.fillSuperview()
        orderSegmentedControl.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 5, rightConstant: 10, widthConstant: 0, heightConstant: 0)
       
    }
    
    func startOrder(_ sender:UISegmentedControl) {
        questionController?.startOrder(sender.selectedSegmentIndex)
    }
    
    
    
}

