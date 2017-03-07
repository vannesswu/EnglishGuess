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
    
    let cellId = "cellId"
    let headerId = "headerId"
    var category:String = ""
    var recordings = [Recording]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TopicCell.self, forCellReuseIdentifier: cellId)
        tableView.register(FilterHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.sectionHeaderHeight = 50
        fetchRecordings()
    }
    
    func fetchRecordings() {
        let recordingsReference = FIRDatabase.database().reference().child("users-recordings").child(category)
     
        recordingsReference.observe(FIRDataEventType.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
            
                for (_,value) in dictionary  {
                if let recordDict = value as? [String: AnyObject] {
                   
                let recording = Recording(dictionary: recordDict)
                 self.recordings.append(recording)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            }, withCancel: nil)
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId)
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
        let recordingDetailVC = RecordingDetailViewController()
        recordingDetailVC.recording = recordings[indexPath.row]
        navigationController?.pushViewController(recordingDetailVC, animated: true)
        
    }
    
    
}


