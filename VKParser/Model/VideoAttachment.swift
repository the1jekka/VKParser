//
//  VideoAttachment.swift
//  VKParser
//
//  Created by Admin on 12.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

class VideoAttachment {
    var id: Int = 0
    var ownerID: Int = 0
    var title: String = ""
    var videoDescription: String = ""
    var date: Int = 0
    var views: Int = 0
    var photoURL: String = ""
    var accessKey: String = ""
    var duration = 0
    
    init(id: Int, ownerID: Int, title: String, videoDescription: String, date: Int, views: Int, photoURL: String, accessKey: String, duration: Int) {
        self.id = id
        self.ownerID = ownerID
        self.title = title
        self.videoDescription = videoDescription
        self.date = date
        self.views = views
        self.photoURL = photoURL
        self.accessKey = accessKey
        self.duration = duration
    }
    
    func putDataToRealmVideoAttachment() -> RealmVideoAttachment {
        let videoAttachment = RealmVideoAttachment()
        videoAttachment.id = id
        videoAttachment.ownerID = ownerID
        videoAttachment.title = title
        videoAttachment.videoDescription = videoDescription
        videoAttachment.date = date
        videoAttachment.views = views
        videoAttachment.photoURL = photoURL
        videoAttachment.accessKey = accessKey
        videoAttachment.duration = duration
        
        return videoAttachment
    }
    
}
