//
//  RecordingCell.swift
//  EnglishGuess
//
//  Created by 吳建豪 on 2017/3/9.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import UIKit
import LBTAComponents


class RecordingCell: TopicCell {
    
    
    var userFilesViewController:UserFilesViewController?
    
    override var recording: Recording?{
        didSet{
            self.topicLabel.text = "\(recording?.category ?? "") : \(recording?.chAnswer ?? "")"
            if let correctRate = recording?.correctRate {
              let  totalCorrectRate = String(format: "%.2f", correctRate*100)
                self.infoLabel.text = "\(recording?.totalClick ?? 0)人答題 答對率\(totalCorrectRate) %"
            }
            
        self.likeLabel.text = "\(recording?.likes ?? 0)"
        self.dislikeLabel.text = "\(recording?.dislikes ?? 0)"
        
        if let seconds = recording?.timeStamp {
            let timestampDate = Date(timeIntervalSince1970: TimeInterval(seconds))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd hh:mm"
            self.timeStampLabel.text =  dateFormatter.string(from: timestampDate)
        }
    }
    
    }


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var infoLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.adoptRed
        return label
    }()
    let topicLabel:UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var playButton:UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(playRecording), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        btn.backgroundColor = UIColor.mainBlue
        return btn
    }()
    
    override func setupViews() {
       
        addSubview(topicLabel)
        addSubview(playButton)
        addSubview(infoLabel)
        addSubview(likeLabel)
        addSubview(likeImageView)
        addSubview(dislikeLabel)
        addSubview(dislikeImageView)
        addSubview(timeStampLabel)
        topicLabel.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 5, leftConstant: 35, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 40)
        infoLabel.anchor(topicLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: playButton.leftAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        playButton.anchor(nil, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 20, widthConstant: 32, heightConstant: 32)
        
        likeImageView.anchor(nil, left: topicLabel.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 15, heightConstant: 15)
        likeImageView.centerYAnchor.constraint(equalTo: topicLabel.centerYAnchor).isActive = true
        likeLabel.anchor(topicLabel.topAnchor, left: likeImageView.rightAnchor, bottom: topicLabel.bottomAnchor, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 0)
        dislikeImageView.anchor(nil, left: likeLabel.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 15, heightConstant: 15)
        dislikeImageView.centerYAnchor.constraint(equalTo: topicLabel.centerYAnchor).isActive = true
        dislikeLabel.anchor(topicLabel.topAnchor, left: dislikeImageView.rightAnchor, bottom: topicLabel.bottomAnchor, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 0)
        timeStampLabel.anchor(topicLabel.topAnchor, left: nil, bottom: topicLabel.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 5, widthConstant: 80, heightConstant: 0)
    }
    
    func playRecording(){
        if let url = recording?.recordingUrl {
        userFilesViewController?.playrecording(url)
        }
    }
    
    
}
