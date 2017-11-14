//
//  RealmPostItems.swift
//  VKParser
//
//  Created by Admin on 12.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class RealmPostItems: Object {
    @objc dynamic var ownerID: Int = 0
    @objc dynamic var postID: Int = 0
    @objc dynamic var date: Int = 0
    @objc dynamic var text: String?
    let attachmentType = List<String>()
    let audioAttachment = List<RealmAudioAttachment>()
    let videoAttachment = List<RealmVideoAttachment>()
    let imageAttachment = List<RealmImageAttachment>()
    @objc dynamic var canDelete = false
    var comments: RealmComments?
    
    func putDataToPostsItems() -> PostItems{
        let postsItems = PostItems()
        postsItems.ownerID = ownerID
        postsItems.postID = postID
        postsItems.date = date
        postsItems.text = text
        postsItems.attachmentType = putDataToAttachmentTypeItem()
        postsItems.videoAttachment = transferVideoAttachments()
        postsItems.audioAttachment = transferAudioAttachments()
        postsItems.imageAttachment = transferImageAttachments()
        postsItems.canDelete = canDelete
        postsItems.comments = comments?.putDataToCommentsItem()
        
        return postsItems
    }
    
    private func putDataToAttachmentTypeItem() -> [String]? {
        var modelAttachmentType: [String]? = nil
        if !attachmentType.isEmpty {
            modelAttachmentType = Array(attachmentType)
        }
        
        return modelAttachmentType
    }
    
    private func transferVideoAttachments() -> [VideoAttachment]? {
        var modelVideoAttachments: [VideoAttachment]? = nil
        if !videoAttachment.isEmpty {
            modelVideoAttachments = [VideoAttachment]()
            for item in videoAttachment {
                modelVideoAttachments?.append(item.putDataToVideoAttachment())
            }
        }
        
        return modelVideoAttachments
    }
    
    private func transferAudioAttachments() -> [AudioAttachment]? {
        var modelAudioAttachments: [AudioAttachment]? = nil
        if !audioAttachment.isEmpty {
            modelAudioAttachments = [AudioAttachment]()
            for item in audioAttachment {
                modelAudioAttachments?.append(item.putDataToAudioAttachment())
            }
        }
        
        return modelAudioAttachments
    }
    
    private func transferImageAttachments() -> [ImageAttachment]? {
        var modelImageAttachments: [ImageAttachment]? = nil
        if !imageAttachment.isEmpty {
            modelImageAttachments = [ImageAttachment]()
            for item in imageAttachment {
                modelImageAttachments?.append(item.putDataToImageAttachment())
            }
        }
        
        return modelImageAttachments
    }
}
