//
//  RealmImageAttachment.swift
//  VKParser
//
//  Created by Admin on 12.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class RealmImageAttachment: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var albumID: Int = 0
    @objc dynamic var ownerID: Int = 0
    @objc dynamic var userID: Int = 0
    @objc dynamic var photoURL: String = ""
    @objc dynamic var width: Int = 0
    @objc dynamic var height: Int = 0
    @objc dynamic var date: Int = 0
    @objc dynamic var accessKey: String? = nil
    
    func putDataToImageAttachment() -> ImageAttachment {
        let imageAttachment = ImageAttachment(id: id, albumID: albumID, ownerID: ownerID, userID: userID, photoURL: photoURL, width: width, height: height, date: date, accessKey: accessKey)
        
        return imageAttachment
    }
}
