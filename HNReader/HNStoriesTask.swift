import Foundation

class HNStoriesTask {
    
    let topNewsURL: NSURL
    let baseStoryURL: String
    var storiesArray: [Story] = []
    
    init() {
        topNewsURL = NSURL(string: "http://node-hnapi-javiman.herokuapp.com/news")!
        baseStoryURL = "http://node-hnapi.herokuapp.com/item/"
    }
    
    func getComments (id: Int, onTaskDone: (comments: [Comment]) -> Void, onTaskError: () -> Void) {
        
        let storyUrl = NSURL(string: "\(baseStoryURL)\(id)") as NSURL!
        
        // Get the top stories form the API
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(storyUrl, completionHandler: { (location: NSURL?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if error == nil {
                // Get the url content as NSData
                let dataObject = NSData(contentsOfURL: location!)
                // Get the story comments
                let comments: [Comment] = self.getCommentsFromData(dataObject!)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onTaskDone(comments: comments)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onTaskError()
                })
            }
        })
        downloadTask.resume()
    }
    
    func getTopStories(onTaskDone: () -> Void, onTaskError: () -> Void) {
        
        // Get the top stories form the API
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(topNewsURL, completionHandler: { (location: NSURL?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if error == nil {
                // Get the url content as NSData
                let dataObject = NSData(contentsOfURL: location!)
                // Get the stories
                self.storiesArray = self.getStoriesFromData(dataObject!)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onTaskDone()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onTaskError()
                })
            }
        })
        downloadTask.resume()
    }
    
    func getCommentsFromData(dataObject: NSData) -> [Comment] {
        let storyObject: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(dataObject, options: [])) as! NSDictionary
        
        var comments: [Comment] = []
        for commentObject in storyObject["comments"] as! NSArray {
            comments.append(Comment(
                id: commentObject["id"] as? Int,
                level: commentObject["level"] as? Int,
                user: commentObject["user"] as? String,
                timeAgo: commentObject["time_ago"] as? String,
                content: commentObject["content"] as? String,
                comments: [] // just first level of comments for now
            ))
        }
        
        return comments
    }
    
    func getStoriesFromData(dataObject: NSData) -> [Story] {
        var storiesArray:[Story] = []
        
        let topStoriesList: NSArray = (try! NSJSONSerialization.JSONObjectWithData(dataObject, options: [])) as! NSArray
        
        for storyObject in topStoriesList {
            
            let story = Story(
                id: storyObject["id"] as? Int,
                title: storyObject["title"] as? String,
                user: storyObject["user"] as? String,
                timeAgo: storyObject["time_ago"] as? String,
                type: storyObject["type"] as? String,
                url: storyObject["url"] as? String,
                points: storyObject["points"] as? Int,
                commentsCount: storyObject["comments_count"] as? Int,
                comments: []
            )
            
            storiesArray.append(story)
        }
        
        return storiesArray
    }
    
}