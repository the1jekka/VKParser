//
//  RealmWall.swift
//  VKParser
//
//  Created by Admin on 12.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class RealmWall: Object {
    let posts = List<RealmPost>()
    
    func putDataToModel() -> Wall{
        let modelWall = Wall()
        
        if !posts.isEmpty {
            modelWall.posts = [Post]()
            for item in posts {
                let modelPost = item.putDataToPost()
                modelWall.posts?.append(modelPost)
            }
        }
        
        return modelWall
    }
}
