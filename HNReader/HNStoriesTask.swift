import Foundation

class HNStoriesTask {
    
    let topNewsURL: NSURL
    var storiesArray: [Story] = []
    
    init() {
        topNewsURL = NSURL(string: "http://node-hnapi-javiman.herokuapp.com/news")!
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