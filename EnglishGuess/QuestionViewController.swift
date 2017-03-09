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
import AVFoundation

class QuestionViewController: UITableViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    var category:String = ""
    var recordingDict = [String:AnyObject]()
    var recordings = [Recording]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleView()
        tableView.register(TopicCell.self, forCellReuseIdentifier: cellId)
        tableView.register(FilterHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.sectionHeaderHeight = 50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recordings = [Recording]()
        fetchRecordings()
        numberOfQLabel.text = "今日已答題數:\(UserDefaults.numberOfQInToday())/10"
    }
    let titleView = UIView()
    let numberOfQLabel = UILabel()
    func setupTitleView() {
        navigationItem.titleView = titleView
        numberOfQLabel.textColor = UIColor.white
        titleView.addSubview(numberOfQLabel)
        numberOfQLabel.anchorCenterSuperview()
    }
    func fetchRecordings() {
        let recordingsReference = FIRDatabase.database().reference().child("users-recordings").child(category)
     
        recordingsReference.observeSingleEvent(of:.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
            
                for (_,value) in dictionary  {
                if let recordDict = value as? [String: AnyObject] {
                   
                let recording = Recording(dictionary: recordDict)
                 self.recordings.append(recording)
                
                    }
                }
                DispatchQueue.main.async {
                    self.startOrder(0)
                    self.tableView.reloadData()
                }
            }
            
            }, withCancel: nil)
    }
    
    
    func startOrder(_ index:Int){
        if index == 0 {
            recordings.sort(by: { (recording1, recording2) -> Bool in
                   return  recording1.timeStamp ?? 0 > recording2.timeStamp ?? 0
            })
            tableView.reloadData()
        }else if index == 1 {
            recordings.sort(by: { (recording1, recording2) -> Bool in
                return  recording1.likes ?? 0 > recording2.likes ?? 0
            })
            tableView.reloadData()
        } else {
            let amount = recordings.count
            popRecordingVC(Int(arc4random_uniform(UInt32(amount))))
            
        }
     //   tableView.reloadData()
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! FilterHeader
        header.questionController = self
        return header
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TopicCell
        cell.recording = recordings[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        popRecordingVC(indexPath.row)
        
    }
    func popRecordingVC(_ index:Int) {
        if UserDefaults.numberOfQInToday() < 10 {
            let answeringVC = AnsweringViewController()
            answeringVC.recording = recordings[index]
            answeringVC.categoary = category
            navigationController?.pushViewController(answeringVC, animated: true)
        } else {
            let alertController = UIAlertController(title: "今日答題次數已滿", message: "點擊廣告回復次數", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }

}


