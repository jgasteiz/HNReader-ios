//
//  Story.swift
//  HNReader
//
//  Created by Javi Manzano on 24/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import Foundation

class Story {
    
    var id: Int?
    var title: String?
    var user: String?
    var timeAgo: String?
    var type: String?
    var url: String?
    var points: Int?
    var commentsCount: Int?
    var content: String?
    
    init(id: Int?, title: String?, user: String?, timeAgo: String?, type: String?, url: String?, points: Int?, commentsCount: Int?, content: String?) {
        self.id = id
        self.title = title
        self.user = user
        self.timeAgo = timeAgo
        self.type = type
        self.url = url
        self.points = points
        self.commentsCount = commentsCount
        self.content = content
    }
    
    ////////////////////////////
    // Getters
    ////////////////////////////
    func getId() -> Int {
        return self.id != nil ? self.id! : -1
    }
    
    func getTitle() -> String {
        return self.title != nil ? self.title! : ""
    }
    
    func getUser() -> String {
        return self.user != nil ? self.user! : ""
    }
    
    func getTimeAgo() -> String {
        return self.timeAgo != nil ? self.timeAgo! : ""
    }
    
    func getType() -> String {
        return self.type != nil ? self.type! : ""
    }
    
    func getURL() -> String {
        if self.url! == "item?id=\(self.getId())" {
            return ""
        }
        return self.url!
    }
    
    func getDisplayURL() -> String {
        if self.url! == "item?id=\(self.getId())" {
            return ""
        }
        let postURL: NSURL = NSURL(string: self.url!)!
        return postURL.host!
    }
    
    func getPoints() -> Int {
        return self.points != nil ? self.points! : 0
    }
    
    func getCommentsCount() -> Int {
        return self.commentsCount != nil ? self.commentsCount! : 0
    }
    
    func getContent() -> String {
        return self.content != nil ? self.content! : ""
    }
    
    ////////////////////////////
    // Other helper functions
    ////////////////////////////
    func hasUser() -> Bool {
        return self.user != nil
    }
    
}