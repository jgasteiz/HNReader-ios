import Foundation

class HNStoriesTask {
    
    let topNewsURL: NSURL
    let storyURL: NSURL
    var storiesArray: [Story] = []
    var storyDetail: NSDictionary = NSDictionary()
    
    init() {
        topNewsURL = NSURL(string: "http://node-hnapi-javiman.herokuapp.com/news")!
        storyURL = NSURL(string: "http://node-hnapi.herokuapp.com/item/10272483")!
    }
    
    func getStory (id: Int, onTaskDone: () -> Void, onTaskError: () -> Void) {
        // Get the top stories form the API
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(storyURL, completionHandler: { (location: NSURL?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if error == nil {
                // Get the url content as NSData
                let dataObject = NSData(contentsOfURL: location!)
                // Get the story
                self.storyDetail = (try! NSJSONSerialization.JSONObjectWithData(dataObject!, options: [])) as! NSDictionary
                
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
                commentsCount: storyObject["comments_count"] as? Int
            )
            
            storiesArray.append(story)
        }
        
        return storiesArray
    }
    
}