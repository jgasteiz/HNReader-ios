//
//  Story.swift
//  HNReader
//
//  Created by Javi Manzano on 24/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import Foundation

class Story {
    var title: String?
    var author: String?
    var id: Int?
    var score: Int?
    var time: Double?
    var type: String?
    var url: String?
    
    init() {
        
    }
    
    func setProperty(key: String, value: AnyObject?) {
        switch key {
        case "title":
            self.title = value as String!
        case "by":
            self.author = value as String!
        case "id":
            self.id = value as Int!
        case "score":
            self.score = value as Int!
        case "time":
            self.time = value as Double!
        case "type":
            self.type = value as String!
        case "url":
            self.url = value as String!
        default:
            break;
        }
    }
}