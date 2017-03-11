//
//  UserFilesViewController.swift
//  EnglishGuess
//
//  Created by 吳建豪 on 2017/3/9.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import LBTAComponents
import Firebase
import UIKit
import AVFoundation

class UserFilesViewController : UITableViewController {
    
    var deleteIndexPath = [IndexPath]()
    var recordings = [Recording]()
    var recordingDict = [String:String]()
    let cellId = "recordingCellId"
    var audioPlayer:AVAudioPlayer!
    var recordingSession: AVAudioSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUseruploadIDs()
        tableView.register(RecordingCell.self, forCellReuseIdentifier: cellId)
        tableView.allowsMultipleSelectionDuringEditing = true
        let rightButton = UIBarButtonItem(title: "編輯", style: UIBarButtonItemStyle.plain, target: self, action: #selector(showEditing))
        self.navigationItem.rightBarButtonItem = rightButton
        setupTitleView()
        
        recordingSession = AVAudioSession.sharedInstance()
        do {
            //     try
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with:.defaultToSpeaker)
            try recordingSession.setActive(true)
        } catch {
            // failed to record!
        }

    }
    
    let titleView = UIView()
    let numberOfQLabel = UploadQuestionLabel()
    
    func setupTitleView(){
        navigationItem.titleView = titleView
        titleView.addSubview(numberOfQLabel)
        numberOfQLabel.anchorCenterSuperview()
    }
    
    func fetchUseruploadIDs() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let userRef = FIRDatabase.database().reference().child("users").child(uid).child("recordings")
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let idDict = snapshot.value as? [String:String] {
          self.recordingDict = idDict
          self.fetchUserRecordings()
        }
        })
       
    }
    func fetchUserRecordings() {
        
        for (id,cat) in recordingDict {
        let recordingsRef = FIRDatabase.database().reference().child("users-recordings").child(cat).child(id)
            recordingsRef.observeSingleEvent(of: .value, with: { (snapshop) in
                
                if let recording = snapshop.value as? [String:AnyObject] {
                    self.recordings.append(Recording(dictionary:recording) )
                    self.attempReloadData()
                }
            })
        }
        
        
    }
    var timer:Timer?
    

    func attempReloadData() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
        
    }
    
    func handleReloadTable() {
        
        self.recordings.sort(by: { (recording1, recording2) -> Bool in
            
            return recording1.timeStamp ?? 0 > recording2.timeStamp ?? 0
        })
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RecordingCell
        cell.recording = recordings[indexPath.row]
        cell.userFilesViewController = self
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     deleteIndexPath.append(indexPath)
        
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let index = deleteIndexPath.index(of: indexPath) {
        deleteIndexPath.remove(at: index)
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        var tempidexPath = [IndexPath]()
        if editingStyle == .delete {
          tempidexPath.append(indexPath)
          deleteRecordings(tempidexPath)
        }
        
       
    }
    func showEditing(sender: UIBarButtonItem)
    {
        if(self.tableView.isEditing == true)
        {
            self.tableView.setEditing(false, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "編輯"
            if deleteIndexPath.count != 0 {
            deleteRecordings(deleteIndexPath)
            }
            deleteIndexPath = [IndexPath]()
        }
        else
        {
        //    self.tableView.isEditing = true
            self.tableView.setEditing(true, animated: true)
    
            self.navigationItem.rightBarButtonItem?.title = "刪除"
        }
    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func deleteRecordings (_ indexPaths:[IndexPath]) {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let sortedIndexPaths = indexPaths.sorted { (indexpath1, indexpath2) -> Bool in
            return indexpath1.row > indexpath2.row
        }
        for indexPath in sortedIndexPaths {
        if let id = self.recordings[indexPath .row].id, let cat = recordingDict[id] {
            FIRDatabase.database().reference().child("users-recordings").child(cat).child(id).removeValue(completionBlock: { (error, ref) in
                
                if error != nil {
                    print("Failed to delete recording:", error ?? "")
                    return
                }
            })
            FIRDatabase.database().reference().child("users").child(uid).child("recordings").child(id).removeValue(completionBlock: { (error, ref) in
                if error != nil {
                    print("Failed to delete recording:", error ?? "")
                    return
                }
                self.recordingDict.removeValue(forKey: id)
                self.recordings.remove(at: indexPath.row)
                self.attempReloadData()
            })
            let numberOfUpload = UserDefaults.numberOfUpload() - 1
            UserDefaults.standard.set(numberOfUpload, forKey: uid+"EnglishGuessUpload")
            numberOfQLabel.update()
        }
     }
    }
}

extension UserFilesViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print ("播放結束")
    }

    func playrecording(_ url:String) {
        fetchRecordingData(url) { (data) in
            self.audioPlayer = try? AVAudioPlayer(data: data)
            self.audioPlayer.delegate = self
            if self.audioPlayer.prepareToPlay() {
                print ("開始播放")
                self.audioPlayer.play()
            }
        }
        
      
    }
    func fetchRecordingData(_ url:String , completion : @escaping (Data) -> ()) {
        if let audioFilename = URL(string:url) {
            URLSession.shared.dataTask(with: audioFilename) { (data, response, error) in
                if error != nil {
                    print (error ?? "")
                }
                if let recordingData = data {
                    DispatchQueue.main.async {
                        completion(recordingData)
                    }
                }
                }.resume()
        }
        
    }
}
