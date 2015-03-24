//
//  HNFetchTask.swift
//  HNReader
//
//  Created by Javi Manzano on 19/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import Foundation

class HNFetchTask {
    
    // *** STEP 1: STORE FIREBASE REFERENCES
    var topStoriesRef: Firebase!
    var storiesArray: [Story] = []
    
    init() {
        // *** STEP 2: SETUP FIREBASE
        topStoriesRef = Firebase(url: "https://hacker-news.firebaseio.com/v0/topstories")
    }
    
    func debounce( delay:NSTimeInterval, queue:dispatch_queue_t, action: (()->()) ) -> ()->() {
        var lastFireTime:dispatch_time_t = 0
        let dispatchDelay = Int64(delay * Double(NSEC_PER_SEC))
        
        return {
            lastFireTime = dispatch_time(DISPATCH_TIME_NOW,0)
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    dispatchDelay
                ),
                queue) {
                    let now = dispatch_time(DISPATCH_TIME_NOW,0)
                    let when = dispatch_time(lastFireTime, dispatchDelay)
                    if now >= when {
                        action()
                    }
            }
        }
    }
    
    func getTopStories(onTaskDone: (stories: [Story]) -> Void, onTaskError: () -> Void) {
        
        let debouncedTaskDone = debounce(
            NSTimeInterval(1),
            queue: dispatch_get_main_queue(),
            {() in
                onTaskDone(stories: self.storiesArray)
            }
        )
        
        // *** STEP 3: RECEIVE DATA FROM FIREBASE
        topStoriesRef.queryLimitedToFirst(30).observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let url = "https://hacker-news.firebaseio.com/v0/item/\(snapshot.value)"
                
            var itemRef = Firebase(url: "https://hacker-news.firebaseio.com/v0/item/\(snapshot.value)") as Firebase!
            var story = Story()
            self.storiesArray.append(story)
            itemRef.observeEventType(.ChildAdded, withBlock: { (snapshot: FDataSnapshot!) in
                story.setProperty(snapshot.key, value: snapshot.value)
                debouncedTaskDone()
            })
        })
    }
}