//
//  Story.swift
//  HNReader
//
//  Created by Javi Manzano on 24/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import Foundation
import RealmSwift

class Story: Object {
    
    dynamic var id = 0
    dynamic var title = ""
    dynamic var user = ""
    dynamic var timeAgo = ""
    dynamic var type = ""
    dynamic var url = ""
    dynamic var points = 0
    dynamic var commentsCount = 0
    dynamic var content = ""
    
    ////////////////////////////
    // Getters
    ////////////////////////////
    func getId() -> Int {
        return self.id
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getUser() -> String {
        return self.user
    }
    
    func getTimeAgo() -> String {
        return self.timeAgo
    }
    
    func getType() -> String {
        return self.type
    }
    
    func getURL() -> String {
        if self.url == "item?id=\(self.getId())" {
            return ""
        }
        return self.url
    }
    
    func getDisplayURL() -> String {
        if self.url == "item?id=\(self.getId())" {
            return ""
        }
        let postURL: NSURL = NSURL(string: self.url)!
        return postURL.host!
    }
    
    func getPoints() -> Int {
        return self.points
    }
    
    func getCommentsCount() -> Int {
        return self.commentsCount
    }
    
    func getContent() -> String {
        return self.content
    }
    
    // Get the post content as HTML, if it has any.
    func getHTMLContent() -> String {
        if self.content == "" {
            return ""
        }
        
        return "\(self.getHTMLHead())\(self.getContent())\(self.getHTMLClose())"
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
        return self.user != ""
    }
    
}