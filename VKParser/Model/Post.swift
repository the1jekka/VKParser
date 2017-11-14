//
//  PostStructure.swift
//  VKParser
//
//  Created by Admin on 12.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

class Post {
    var myPost: PostItems?
    var repost: PostItems?
    
    func putDataToRealmPost() -> RealmPost {
        let realmPost = RealmPost()
        
        if let post = myPost {
            realmPost.myPost = post.putDataToRealmPostsItems()
        }
        
        if let post = repost {
            realmPost.repost = post.putDataToRealmPostsItems()
        }
        
        return realmPost
    }
}
