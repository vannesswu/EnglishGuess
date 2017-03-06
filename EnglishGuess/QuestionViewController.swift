//
//  QuestionViewController.swift
//  EnglishGuess
//
//  Created by 吳建豪 on 2017/3/7.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import LBTAComponents
import Firebase


class QuestionViewController: UITableViewController {
    
    var category:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = category ?? ""
        
        
    }
    
    
    
    
}
