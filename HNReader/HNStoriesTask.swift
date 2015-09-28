import Foundation

class HNStoriesTask {
    
    let topNewsURL: NSURL
    let nextThirtyURL: NSURL
    let baseStoryURL: String
    
    init() {
        topNewsURL = NSURL(string: "http://node-hnapi-javiman.herokuapp.com/news")!
        nextThirtyURL = NSURL(string: "http://node-hnapi-javiman.herokuapp.com/news2")!
        baseStoryURL = "http://node-hnapi-javiman.herokuapp.com/item/"
    }
    
    ////////////////////////////
    // Stories methods
    ////////////////////////////
    
    // Get the first 30 stories
    func getTopStories(onTaskDone: ([Story], Bool) -> Void, onTaskError: () -> Void) {
        self.fetchStories(topNewsURL, firstThirtyStories: true, onTaskDone: onTaskDone, onTaskError: onTaskError)
    }
    
    // Get the next 30 stories
    func getNextThirtyStories(onTaskDone: ([Story], Bool) -> Void, onTaskError: () -> Void) {
        self.fetchStories(nextThirtyURL, firstThirtyStories: false, onTaskDone: onTaskDone, onTaskError: onTaskError)
    }
    
    // Given an api url, a boolean and callbacks, fetch 30 stories from the API.
    func fetchStories(storiesURL: NSURL, firstThirtyStories: Bool, onTaskDone: ([Story], Bool) -> Void, onTaskError: () -> Void) -> Void {
        
        // Get the top stories
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(storiesURL, completionHandler: { (location: NSURL?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if error == nil {
                // Get the url content as NSData
                let dataObject = NSData(contentsOfURL: location!)
                
                // Get the stories
                var stories: [Story] = []
                
                let storiesArray: NSArray = (try! NSJSONSerialization.JSONObjectWithData(dataObject!, options: [])) as! NSArray
                
                // Add the fetched stories to the array
                for storyDict in storiesArray {
                    stories.append(Story(
                        id: storyDict["id"] as? Int,
                        title: storyDict["title"] as? String,
                        user: storyDict["user"] as? String,
                        timeAgo: storyDict["time_ago"] as? String,
                        type: storyDict["type"] as? String,
                        url: storyDict["url"] as? String,
                        points: storyDict["points"] as? Int,
                        commentsCount: storyDict["comments_count"] as? Int
                    ))
                }
                
                // Perform the dispatch async with the fetched stories
                // and the boolean value of firstThirtyStories.
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onTaskDone(stories, firstThirtyStories)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onTaskError()
                })
            }
        })
        
        // Perform the API call.
        downloadTask.resume()
    }
    
    ////////////////////////////
    // Comments methods
    ////////////////////////////
    
    // Given a story id, fetch all of its comments.
    func getStoryComments (storyId: Int, onTaskDone: (comments: [Comment]) -> Void, onTaskError: () -> Void) -> Void {
        
        let storyURL = NSURL(string: "\(baseStoryURL)\(storyId)") as NSURL!
        
        self.fetchComments(storyURL, onTaskDone: onTaskDone, onTaskError: onTaskError)
    }
    
    func fetchComments(storyURL: NSURL, onTaskDone: (comments: [Comment]) -> Void, onTaskError: () -> Void) -> Void {
        
        // Get the top stories form the API
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(storyURL, completionHandler: { (location: NSURL?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if error == nil {
                // Get the url content as NSData
                let dataObject = NSData(contentsOfURL: location!)
                // Get the story object
                let storyObject: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(dataObject!, options: [])) as! NSDictionary
                
                // Get all the comments for the story in a list.
                let allComments: [Comment] = self.getAllComments(storyObject, comments: [])
                
                // Send the list back.
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onTaskDone(comments: allComments)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onTaskError()
                })
            }
        })
        downloadTask.resume()
    }
    
    // Given a comment NSDictionary, which could have more comments, return
    // a single level list of all the comments and their children,
    // in hierarchical order.
    func getAllComments (comment: NSDictionary, var comments: [Comment]) -> [Comment] {
        
        // Loop through the comment dictionary comments
        for commentObject in comment["comments"] as! NSArray {
            
            // Create a new comment and add it to the general list of comments
            comments.append(Comment(
                id: commentObject["id"] as? Int,
                level: commentObject["level"] as? Int,
                user: commentObject["user"] as? String,
                timeAgo: commentObject["time_ago"] as? String,
                content: commentObject["content"] as? String
            ))
            
            // If the comment has comments, fetch them and add them to the list.
            if commentObject["comments"] != nil {
                comments = comments + self.getAllComments(commentObject as! NSDictionary, comments: [])
            }
        }
        
        // Return all the comments for the given comment.
        return comments
    }
    
}