//
//  ImageAttachment.swift
//  VKParser
//
//  Created by Admin on 12.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

class ImageAttachment {
    var id: Int = 0
    var albumID: Int = 0
    var ownerID: Int = 0
    var userID: Int = 0
    var photoURL: String = ""
    var width: Int = 0
    var height: Int = 0
    var date: Int = 0
    var accessKey: String? = ""
    
    init(id: Int, albumID: Int, ownerID: Int, userID: Int, photoURL: String, width: Int, height: Int, date: Int, accessKey: String?) {
        self.id = id
        self.albumID = albumID
        self.ownerID = ownerID
        self.userID = userID
        self.photoURL = photoURL
        self.width = width
        self.height = height
        self.date = date
        self.accessKey = accessKey
    }
    
    func putDataToRealmImageAttachment() -> RealmImageAttachment {
        let imageAttachment = RealmImageAttachment()
        imageAttachment.id = id
        imageAttachment.ownerID = ownerID
        imageAttachment.userID = userID
        imageAttachment.date = date
        imageAttachment.width = width
        imageAttachment.photoURL = photoURL
        imageAttachment.accessKey = accessKey
        imageAttachment.height = height
        
        return imageAttachment
    }
}
