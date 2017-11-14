//
//  PostsCell.swift
//  VKParser
//
//  Created by Admin on 13.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class PostsCell: UITableViewCell {

    
    let postTextLabel: UILabel = {
        let text = UILabel()
        text.numberOfLines = 0
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 16)
        return text
    }()
    
    let dateLabel: UILabel = {
        let date = UILabel()
        date.textColor = .lightGray
        //date.isEditable = false
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    let postSender: UITextView = {
        let sender = UITextView()
        sender.isSelectable = false
        sender.isEditable = false
        sender.translatesAutoresizingMaskIntoConstraints = false
        return sender
    }()
    
    let senderAvatar: UIImageView = {
        let avatar = UIImageView()
        avatar.layer.cornerRadius = 32
        avatar.layer.masksToBounds = true
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.backgroundColor = .magenta
        return avatar
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(postTextLabel)
        addSubview(dateLabel)
        addSubview(postSender)
        addSubview(senderAvatar)
        
        setupSenderAvatar()
        setupPostSender()
        setupDateLabel()
        setupPostTextLabel()
    }
    
    func setupSenderAvatar() {
        senderAvatar.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        senderAvatar.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        senderAvatar.widthAnchor.constraint(equalToConstant: 64).isActive = true
        senderAvatar.heightAnchor.constraint(equalToConstant: 64).isActive = true
    }
    
    func setupPostSender() {
        postSender.leftAnchor.constraint(equalTo: senderAvatar.rightAnchor, constant: 8).isActive = true
        postSender.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        postSender.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        postSender.heightAnchor.constraint(equalTo: senderAvatar.heightAnchor, multiplier: 1/2).isActive = true
    }
    
    func setupPostTextLabel() {
        postTextLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        postTextLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        postTextLabel.topAnchor.constraint(equalTo: senderAvatar.bottomAnchor, constant: 8).isActive = true
        postTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func setupDateLabel() {
        dateLabel.leftAnchor.constraint(equalTo: postSender.leftAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: postSender.rightAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: postSender.bottomAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: senderAvatar.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
