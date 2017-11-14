//
//  PostItems.swift
//  VKParser
//
//  Created by Admin on 12.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class PostItems {
    var ownerID: Int = 0
    var postID: Int = 0
    var date: Int = 0
    var text: String?
    var attachmentType: [String]?
    var audioAttachment: [AudioAttachment]?
    var videoAttachment: [VideoAttachment]?
    var imageAttachment: [ImageAttachment]?
    var canDelete: Bool = false
    var comments: Comments?
    
    func putDataToRealmPostsItems() -> RealmPostItems{
        let postsItems = RealmPostItems()
        postsItems.ownerID = ownerID
        postsItems.postID = postID
        postsItems.date = date
        postsItems.text = text
        postsItems.attachmentType.append(objectsIn: putDataToRealmAttachmentTypeItem())
        postsItems.videoAttachment.append(objectsIn: transferVideoAttachments())
        postsItems.audioAttachment.append(objectsIn: transferAudioAttachments())
        postsItems.imageAttachment.append(objectsIn: transferImageAttachments())
        postsItems.canDelete = canDelete
        postsItems.comments = comments?.putDataToRealmCommentsItem()
        
        return postsItems
    }
    
    private func putDataToRealmAttachmentTypeItem() -> List<String> {
        let realmAttachmentType = List<String>()
        if let attachmentsType = attachmentType {
            for item in attachmentsType {
                realmAttachmentType.append(item)
            }
        }
        
        return realmAttachmentType
    }
    
    private func transferVideoAttachments() -> List<RealmVideoAttachment> {
        let realmVideoAttachments = List<RealmVideoAttachment>()
        if let videos = videoAttachment {
            for item in videos {
                realmVideoAttachments.append(item.putDataToRealmVideoAttachment())
            }
        }
        
        return realmVideoAttachments
    }
    
    private func transferAudioAttachments() -> List<RealmAudioAttachment> {
        let realmAudioAttachments = List<RealmAudioAttachment>()
        if let audios = audioAttachment {
            for item in audios {
                realmAudioAttachments.append(item.putDataToRealmAudioAttachment())
            }
        }
        
        return realmAudioAttachments
    }
    
    private func transferImageAttachments() -> List<RealmImageAttachment> {
        let realmImageAttachments = List<RealmImageAttachment>()
        if let images = imageAttachment {
            for item in images {
                realmImageAttachments.append(item.putDataToRealmImageAttachment())
            }
        }
        
        return realmImageAttachments
    }
}
