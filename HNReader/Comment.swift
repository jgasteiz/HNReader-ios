//
//  Story.swift
//  HNReader
//
//  Created by Javi Manzano on 24/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import Foundation
import UIKit

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
        
        // Calulate the padding left depending on the level
        let paddingLeft = 5 + self.getLevel() * 5
        let borderLeft = self.getLevel() * 5

        // If this is a reply, show an arrow before the user name
        let headerPrefix = self.getLevel() > 0 ? "↳" : ""
        
        // If this is a reply, also remove the left padding
        let marginLeft = self.getLevel() > 0 ? "-5px" : "0"
        
        // The horror. Fix this.
        return
            "<div style=\"margin-bottom: 20px; margin-left:\(marginLeft); border-left: \(borderLeft)px solid #F60; padding: 0 5px 0 \(paddingLeft)px;\">" +
                "<header>" +
                    "\(headerPrefix)<strong>\(self.getUser())</strong>, <em>\(self.getTimeAgo())</em>" +
                "</header>" +
                "<div>\(commentText)</div>" +
            "</div>"
    }
    
    func getComments() -> [Comment] {
        return self.comments != nil ? self.comments! : []
    }
    
    //////////////
    // Helpers
    //////////////
    func html2String(html:String) -> String {
        return try! NSAttributedString(
            data: html.dataUsingEncoding(NSUTF8StringEncoding)!,
            options:[NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding],
            documentAttributes: nil).string
    }
}