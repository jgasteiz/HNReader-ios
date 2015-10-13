import Foundation
import RealmSwift

class HNStoriesTask {
    
    let topNewsURL: NSURL
    let nextThirtyURL: NSURL
    let baseStoryURL: String
    
    let realm = try! Realm()
    
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
    
    // Get a story
    func getStoryDetail(storyId: Int, onTaskDone: (Story) -> Void, onTaskError: () -> Void) {
        let storyURL = NSURL(string: "\(baseStoryURL)\(storyId)") as NSURL!
        
        self.fetchStory(storyURL, onTaskDone: onTaskDone, onTaskError: onTaskError)
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
//                var stories: [Story] = []
                
                let storiesArray: NSArray = (try! NSJSONSerialization.JSONObjectWithData(dataObject!, options: [])) as! NSArray
                
                // Add the fetched stories to the array
                for storyDict in storiesArray {
                    self.realm.beginWrite()
                    let story = Story()
                    story.id = storyDict["id"] as! Int
                    story.title = storyDict["title"] as! String
                    story.user = storyDict["user"] as! String
                    story.timeAgo = storyDict["time_ago"] as! String
                    story.type = storyDict["type"] as! String
                    story.url = storyDict["url"] as! String
                    story.points = storyDict["points"] as! Int
                    story.commentsCount = storyDict["comments_count"] as! Int
                    story.content = storyDict["content"] as! String
                    self.realm.add(story)
                    self.realm.commitWrite()
                }
                
                // Perform the dispatch async with the fetched stories
                // and the boolean value of firstThirtyStories.
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onTaskDone([], firstThirtyStories)
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
    
    // Fetch a single story
    func fetchStory(storyURL: NSURL, onTaskDone: (story: Story) -> Void, onTaskError: () -> Void) -> Void {
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(storyURL, completionHandler: { (location: NSURL?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if error == nil {
                // Get the url content as NSData
                let dataObject = NSData(contentsOfURL: location!)
                // Get the story object
                let storyDict: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(dataObject!, options: [])) as! NSDictionary
                
                let story: Story = Story()
                story.content = storyDict["content"] as! String
                
                // Send the list back.
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onTaskDone(story: story)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onTaskError()
                })
            }
        })
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