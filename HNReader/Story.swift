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
    var comments: [Comment] = []
    
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
    
    // Get the post content as HTML, if it has any.
    func getHTMLContent() -> String {
        if self.content == nil {
            return ""
        }
        
        return "\(self.getHTMLHead())\(self.getContent())\(self.getHTMLClose())"
    }
    
    // Get the post comments as HTML, if it has any.
    func getHTMLComments() -> String {
        if self.comments.count == 0 {
            return ""
        }
        
        var htmlContent: String = ""
        
        for comment in self.comments {
            htmlContent = "\(htmlContent)\(comment.getContent())"
        }
        
        return "\(self.getHTMLHead())\(htmlContent)\(self.getHTMLClose())"
    }
    
    // Return the top tags and styles of a HTML document.
    func getHTMLHead() -> String {
        return "<html><head>" +
            "<style>" +
            "* { word-wrap: break-word; font-family: Helvetica; }" +
            "p { margin: 10px 0; }" +
            ".comment { border-bottom: 1px solid #E0E0E0; padding: 10px 5px; }" +
            "</style>" +
        "</head><body>"
    }
    
    // Return the closing tags of a HTML document.
    func getHTMLClose() -> String {
        return "</body></html>"
    }
    
    ////////////////////////////
    // Other helper functions
    ////////////////////////////
    func hasUser() -> Bool {
        return self.user != nil
    }
    
}