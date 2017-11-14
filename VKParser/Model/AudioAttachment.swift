//
//  AudioAttachment.swift
//  VKParser
//
//  Created by Admin on 12.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

class AudioAttachment {
    var id: Int = 0
    var ownerID: Int = 0
    var artist: String = ""
    var title: String = ""
    var duration: Int = 0
    var url: String = ""
    var date: Int = 0
    
    init(id: Int, ownerID: Int, artist: String, title: String, duration: Int, url: String, date: Int) {
        self.id = id
        self.ownerID = ownerID
        self.artist = artist
        self.title = title
        self.duration = duration
        self.url = url
        self.date = date
    }
    
    func putDataToRealmAudioAttachment() -> RealmAudioAttachment {
        let audioAttachment = RealmAudioAttachment()
        audioAttachment.id = id
        audioAttachment.ownerID = ownerID
        audioAttachment.title = title
        audioAttachment.artist = artist
        audioAttachment.date = date
        audioAttachment.url = url
        audioAttachment.duration = duration
        
        return audioAttachment
    }
}
