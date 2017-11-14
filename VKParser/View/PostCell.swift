//
//  PostCell.swift
//  VKParser
//
//  Created by Admin on 14.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    var images: [ImageAttachment]? {
        didSet {
            prepareImagesButton()
        }
    }
    var videos: [VideoAttachment]? {
        didSet {
            prepareVideosButton()
        }
    }
    var audios: [AudioAttachment]? {
        didSet {
            prepareAudiosButton()
        }
    }
    
    let postText: UITextView = {
        let postText = UITextView()
        postText.isEditable = false
        postText.isSelectable = false
        postText.translatesAutoresizingMaskIntoConstraints = false
        
        return postText
    }()
    
    let postDate: UITextView = {
        let postDate = UITextView()
        postDate.isEditable = false
        postDate.isSelectable = false
        postDate.translatesAutoresizingMaskIntoConstraints = false
        
        return postDate
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
    
    let imagesButton: ImageButton = {
        let imagesButton = ImageButton(type: .system)
        imagesButton.setTitle("Images", for: .normal)
        imagesButton.translatesAutoresizingMaskIntoConstraints = false
        return imagesButton
    }()
    
    let audiosButton: AudioButton = {
        let audiosButton = AudioButton(type: .system)
        audiosButton.setTitle("Audios", for: .normal)
        audiosButton.translatesAutoresizingMaskIntoConstraints = false
        return audiosButton
    }()
    
    let videosButton: VideoButton = {
        let videosButton = VideoButton(type: .system)
        videosButton.setTitle("Videos", for: .normal)
        videosButton.translatesAutoresizingMaskIntoConstraints = false
        return videosButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(postSender)
        addSubview(senderAvatar)
        addSubview(postDate)
        addSubview(postText)
        addSubview(videosButton)
        addSubview(audiosButton)
        addSubview(imagesButton)
        
        setupSenderAvatar()
        setupPostSender()
        setupPostDate()
        setupPostText()
        setupImagesButton()
        setupVideosButton()
        setupAudiosButton()
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
    
    func setupPostDate() {
        postDate.leftAnchor.constraint(equalTo: senderAvatar.rightAnchor, constant: 8).isActive = true
        postDate.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        postDate.topAnchor.constraint(equalTo: postSender.bottomAnchor).isActive = true
        postDate.heightAnchor.constraint(equalTo: senderAvatar.heightAnchor, multiplier: 1 / 2).isActive = true
    }
    
    func setupPostText() {
        postText.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        postText.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        postText.topAnchor.constraint(equalTo: postDate.bottomAnchor, constant: 8).isActive = true
        postText.bottomAnchor.constraint(equalTo: imagesButton.topAnchor, constant: -8).isActive = true
    }
    
    private func prepareImagesButton() {
        if let imageAttachment = images {
            imagesButton.isEnabled = true
            imagesButton.setTitleColor(.blue, for: .normal)
            imagesButton.images = imageAttachment
        } else {
            imagesButton.isEnabled = false
            imagesButton.setTitleColor(.lightGray, for: .normal)
        }
    }
    
    func setupImagesButton() {
        imagesButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imagesButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imagesButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 3).isActive = true
        imagesButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func prepareVideosButton() {
        if let videoAttachment = videos {
            videosButton.isEnabled = true
            videosButton.setTitleColor(.blue, for: .normal)
            videosButton.videos = videoAttachment
        } else {
            videosButton.isEnabled = false
            videosButton.setTitleColor(.lightGray, for: .normal)
        }
    }
    
    func setupVideosButton() {
        videosButton.leftAnchor.constraint(equalTo: imagesButton.rightAnchor).isActive = true
        videosButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videosButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 3).isActive = true
        videosButton.heightAnchor.constraint(equalTo: imagesButton.heightAnchor).isActive = true
    }
    
    private func prepareAudiosButton() {
        if let audiosAttachments = audios {
            audiosButton.isEnabled = true
            audiosButton.setTitleColor(.blue, for: .normal)
            audiosButton.audios = audiosAttachments
        } else {
            audiosButton.isEnabled = false
            audiosButton.setTitleColor(.lightGray, for: .normal)
        }
    }
    
    func setupAudiosButton() {
        audiosButton.leftAnchor.constraint(equalTo: videosButton.rightAnchor).isActive = true
        audiosButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        audiosButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 3).isActive = true
        audiosButton.heightAnchor.constraint(equalTo: imagesButton.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
