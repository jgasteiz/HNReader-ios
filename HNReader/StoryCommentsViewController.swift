//
//  StoryDetailViewController.swift
//  HNReader
//
//  Created by Javi Manzano on 25/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import UIKit

class StoryCommentsViewController: UIViewController {
    
    var hnStoriesTask = HNStoriesTask()
    
    var commentList: NSArray = NSArray()
    
    var storyTitle: String?
    var storyId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = self.storyTitle
        
        fetchComments()
    }
    
    @IBOutlet weak var commentsContent: UIWebView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchComments() {
        hnStoriesTask.getComments(self.storyId!, onTaskDone: onGetPostsSuccess, onTaskError: onGetPostsError)
    }
    
    func onGetPostsSuccess(comments: [Comment]) {
        self.commentList = comments
        
        // The horror. Fix this.
        var htmlContent: String = "<html><head><style>*{word-wrap:break-word;font-family:Helvetica;}p{margin: 10px 0;}</style></head><body>"
        
        for comment in comments {
            htmlContent = "\(htmlContent)\(comment.getContent())"
        }
        
        // The horror. Fix this.
        htmlContent = "\(htmlContent)</body></html>"
        
        commentsContent.loadHTMLString(htmlContent as String, baseURL: nil)
    }
    
    func onGetPostsError() {
        // do something!
        
        // Show error message
        let alertController = UIAlertController(title: "Ooops", message:
            "There was an error fetching the top stories. Please, try again later.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
