//
//  RealmPost.swift
//  VKParser
//
//  Created by Admin on 12.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class RealmPost: Object {
    @objc dynamic var myPost: RealmPostItems?
    @objc dynamic var repost: RealmPostItems?
    
    func putDataToPost() -> Post {
        let modelPost = Post()
        
        if let post = myPost {
            modelPost.myPost = post.putDataToPostsItems()
        }
        
        if let post = repost {
            modelPost.repost = post.putDataToPostsItems()
        }
        
        return modelPost
    }
}
