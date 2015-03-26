//
//  HNFetchTask.swift
//  HNReader
//
//  Created by Javi Manzano on 19/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import Foundation

class HNFetchTask {
    
    var topStoriesRef: Firebase
    var itemRef: Firebase
    var storiesArray: [Story] = []
    
    init() {
        topStoriesRef = Firebase(url: "https://hacker-news.firebaseio.com/v0/topstories")
        itemRef = Firebase(url: "https://hacker-news.firebaseio.com/v0/item/")
    }
    
    func debounce(delay: NSTimeInterval, queue: dispatch_queue_t, action: (() -> ())) -> () -> () {
        var lastFireTime: dispatch_time_t = 0
        let dispatchDelay = Int64(delay * Double(NSEC_PER_SEC))
        
        return {
            lastFireTime = dispatch_time(DISPATCH_TIME_NOW, 0)
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    dispatchDelay
                ),
                queue) {
                    let now = dispatch_time(DISPATCH_TIME_NOW, 0)
                    let when = dispatch_time(lastFireTime, dispatchDelay)
                    if now >= when {
                        lastFireTime = dispatch_time(DISPATCH_TIME_NOW, 0)
                        println("Debounced worked: \(now), \(when)")
                        action()
                    }
            }
        }
    }
    
    func getTopStories(onTaskDone: (stories: [Story]) -> Void, onTaskError: () -> Void) {
        
        storiesArray = []
        
        let debouncedTaskDone = debounce(
            NSTimeInterval(0.5),
            queue: dispatch_get_main_queue(),
            { _ in
                println("DEBOUNCE in task")
                onTaskDone(stories: self.storiesArray)
            }
        )
        
        // Fetch and observe the first 30 items in the Top Stories
        topStoriesRef.queryLimitedToFirst(30).observeSingleEventOfType(.Value, withBlock: { (idListSnapshot) in
            
            let storyIdList: [Int] = idListSnapshot.value as [Int]
            
            for storyId in storyIdList {
                
                // Fetch and observe the item in place.
                self.itemRef.childByAppendingPath(String(storyId)).observeSingleEventOfType(.Value, withBlock: { storySnapshot in
                    
                    let id = storySnapshot.value["id"] as Int!
                    let title = storySnapshot.value["title"] as String!
                    let author = storySnapshot.value["by"] as String!
                    let time = storySnapshot.value["time"] as Double!
                    let type = storySnapshot.value["type"] as String!
                    let url = storySnapshot.value["url"] as String!
                    let score = storySnapshot.value["score"] as Int!
                    
                    let story = Story(id: id, title: title, author: author, time: time, type: type, url: url, score: score)
                    
                    self.storiesArray.append(story)
                    
                    debouncedTaskDone()
                })
            }
        })
    }
}