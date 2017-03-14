//
//  TopicCell.swift
//  EnglishGuess
//
//  Created by 吳建豪 on 2017/3/7.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import UIKit
import LBTAComponents
class TopicCell: UITableViewCell {
    
    var recording:Recording? {
        
        didSet {
            if let url = recording?.profileImageUrl {
            self.profileImageView.loadImage(urlString: url, completion: {
                self.spinner.stopAnimating()
            })
            }
            self.nameLabel.text = recording?.userName ?? ""
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
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let spinner = UIActivityIndicatorView.spinner
    let profileImageView: CachedImageView = {
        let iv = CachedImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 30
        return iv
    }()
    let nameLabel:UILabel = {
        let bl = UILabel()
        bl.adjustsFontSizeToFitWidth = true
        return bl
    }()
    let likeLabel:UILabel = {
        let bl = UILabel()
        bl.adjustsFontSizeToFitWidth = true
        bl.textAlignment = .center
        return bl
    }()
    let dislikeLabel:UILabel = {
        let bl = UILabel()
        bl.adjustsFontSizeToFitWidth = true
        bl.textAlignment = .center
        return bl
    }()
    let likeImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "like")
        return iv
    }()
    let dislikeImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "dislike")
        return iv
    }()
    let timeStampLabel:UILabel = {
        let bl = UILabel()
        bl.font = UIFont.systemFont(ofSize: 13)
        bl.textColor = UIColor.darkGray
        return bl
    }()
    
    func setupViews(){
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(likeLabel)
        addSubview(likeImageView)
        addSubview(dislikeLabel)
        addSubview(dislikeImageView)
        addSubview(timeStampLabel)
        let width = frame.size.width
        profileImageView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 5, leftConstant: 5, bottomConstant: 5, rightConstant: 5, widthConstant: width/6, heightConstant: 0)
        profileImageView.addSubview(spinner)
        spinner.anchorCenterSuperview()
        spinner.startAnimating()
        nameLabel.anchor(profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: profileImageView.bottomAnchor, right: likeImageView.leftAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        likeImageView.anchor(nil, left: nil, bottom: nil, right: likeLabel.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 15, heightConstant: 15)
        likeImageView.anchorCenterYToSuperview()
        likeLabel.anchor(profileImageView.topAnchor, left: nil, bottom: profileImageView.bottomAnchor, right: dislikeImageView.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 0)
        dislikeImageView.anchor(nil, left: nil, bottom: nil, right: dislikeLabel.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 15, heightConstant: 15)
        dislikeImageView.anchorCenterYToSuperview()
        dislikeLabel.anchor(profileImageView.topAnchor, left: nil, bottom: profileImageView.bottomAnchor, right: timeStampLabel.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 0)
        timeStampLabel.anchor(profileImageView.topAnchor, left: nil, bottom: profileImageView.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 5, widthConstant: width/4, heightConstant: 0)
    }
    
    
    
}
