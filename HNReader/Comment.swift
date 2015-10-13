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
    
    init(id: Int?, level: Int?, user: String?, timeAgo: String?, content: String?) {
        self.id = id
        self.level = level
        self.user = user
        self.timeAgo = timeAgo
        self.content = content
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
    
    func getTimeAgo() -> String {
        return self.timeAgo != nil ? self.timeAgo! : ""
    }
    
    func getAuthor() -> String {
        let user = self.user != nil ? self.user! : ""
        if self.getLevel() == 0 {
            return "\(user)"
        } else {
            return "⤷ \(user)"
        }
    }
    
    func getTextContent() -> String {
        let commentText = self.content != nil ? self.content! : ""
        return self.html2String(commentText)
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