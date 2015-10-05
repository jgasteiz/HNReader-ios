//
//  StoryDetailViewController.swift
//  HNReader
//
//  Created by Javi Manzano on 25/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import UIKit

class StoryCommentsController: UIViewController {
    
    var hnStoriesTask = HNStoriesTask()
    
    var story: Story?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = self.story!.getTitle()
        
        fetchComments()
    }
    
    @IBOutlet weak var commentsContent: UIWebView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchComments() {
        hnStoriesTask.getStoryComments(self.story!.getId(), onTaskDone: onGetCommentsSuccess, onTaskError: onGetPostsError)
    }
    
    func onGetCommentsSuccess(comments: [Comment]) {
        self.story!.comments = comments
        commentsContent.loadHTMLString(self.story!.getHTMLComments() as String, baseURL: nil)
    }
    
    func onGetPostsError() {
        // Show error message
        let alertController = UIAlertController(title: "Ooops", message:
            "There was an error fetching the top stories. Please, try again later.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
