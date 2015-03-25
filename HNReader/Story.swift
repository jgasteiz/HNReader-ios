//
//  Story.swift
//  HNReader
//
//  Created by Javi Manzano on 24/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import Foundation

class Story {
    var id: Int
    var title: String
    var author: String?
    var score: Int?
    var time: Double
    var type: String
    var url: String?
    
    init(id: Int, title: String, author: String?, time: Double, type: String, url: String?, score: Int?) {
        self.id = id
        self.title = title
        self.author = author
        self.time = time
        self.type = type
        self.url = url
        self.score = score
    }    
}