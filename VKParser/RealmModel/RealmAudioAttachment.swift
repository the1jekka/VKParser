//
//  RealmAudioAttachment.swift
//  VKParser
//
//  Created by Admin on 12.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class RealmAudioAttachment: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerID: Int = 0
    @objc dynamic var artist: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var duration: Int = 0
    @objc dynamic var url: String = ""
    @objc dynamic var date: Int = 0
    
    
    func putDataToAudioAttachment() -> AudioAttachment {
        let audioAttachment = AudioAttachment(id: id, ownerID: ownerID, artist: artist, title: title, duration: duration, url: url, date: date)
        
        return audioAttachment
    }
}
