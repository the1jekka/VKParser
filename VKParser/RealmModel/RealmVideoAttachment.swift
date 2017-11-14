//
//  RealmVideoAttachment.swift
//  VKParser
//
//  Created by Admin on 12.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class RealmVideoAttachment: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerID: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var videoDescription: String = ""
    @objc dynamic var date: Int = 0
    @objc dynamic var views: Int = 0
    @objc dynamic var photoURL: String = ""
    @objc dynamic var accessKey: String = ""
    @objc dynamic var duration = 0
    
    func putDataToVideoAttachment() -> VideoAttachment {
        let videoAttachment = VideoAttachment(id: id, ownerID: ownerID, title: title, videoDescription: videoDescription, date: date, views: views, photoURL: photoURL, accessKey: accessKey, duration: duration)
        
        return videoAttachment
    }
}
