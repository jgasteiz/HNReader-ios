//
//  Story.swift
//  HNReader
//
//  Created by Javi Manzano on 24/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import Foundation

class Comment {
    
    var id: Int?
    var level: Int?
    var user: String?
    var timeAgo: String?
    var content: String?
    var comments: [Comment]?
    
    init(id: Int?, level: Int?, user: String?, timeAgo: String?, content: String?, comments: [Comment]?) {
        self.id = id
        self.level = level
        self.user = user
        self.timeAgo = timeAgo
        self.content = content
        self.comments = comments
    }
    
    ////////////////////////////
    // Getters
    ////////////////////////////
    func getId() -> Int {
        return self.id != nil ? self.id! : -1
    }
    
    func getLevel() -> Int {
        return self.level != nil ? self.level! : 0
    }
    
    func getUser() -> String {
        return self.user != nil ? self.user! : ""
    }
    
    func getTimeAgo() -> String {
        return self.timeAgo != nil ? self.timeAgo! : ""
    }
    
    func getContent() -> String {
        let commentText = self.content != nil ? self.content! : ""
        return "\(self.getUser()), \(self.getTimeAgo()):\n\(commentText)"
    }
    
    func getComments() -> [Comment] {
        return self.comments != nil ? self.comments! : []
    }
}