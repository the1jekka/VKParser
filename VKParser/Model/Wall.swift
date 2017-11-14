//
//  Wall.swift
//  VKParser
//
//  Created by Admin on 12.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation

class Wall {
    var posts: Array<Post>? = nil
    
    func putDataToRealmModel() -> RealmWall{
        let realmWall = RealmWall()
        
        if let wallPosts = posts {
            for post in wallPosts {
                let realmPost = post.putDataToRealmPost()
                realmWall.posts.append(realmPost)
            }
        }
        
        return realmWall
    }
}
