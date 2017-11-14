//
//  RealmComments.swift
//  VKParser
//
//  Created by Admin on 12.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class RealmComments: Object {
    @objc dynamic var count: Int = 0
    @objc dynamic var groupsCanPost: Bool = false
    @objc dynamic var canPost: Bool = false
    
    func putDataToCommentsItem() -> Comments{
        let comments = Comments()
        comments.count = count
        comments.groupsCanPost = groupsCanPost
        comments.canPost = canPost
        
        return comments
    }
}
