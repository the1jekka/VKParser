//
//  Comments.swift
//  VKParser
//
//  Created by Admin on 12.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

class Comments {
    var count: Int = 0
    var groupsCanPost: Bool = false
    var canPost: Bool = false
    
    func putDataToRealmCommentsItem() -> RealmComments{
        let realmComments = RealmComments()
        realmComments.count = count
        realmComments.groupsCanPost = groupsCanPost
        realmComments.canPost = canPost
        
        return realmComments
    }
}
