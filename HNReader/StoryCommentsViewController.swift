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
    
    var storyTitle: String?
    var storyId: Int?
    
    @IBOutlet weak var content: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.title = self.storyTitle
        
        fetchComments()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchComments() {
        hnStoriesTask.getStory(self.storyId!, onTaskDone: onGetPostsSuccess, onTaskError: onGetPostsError)
    }
    
    func onGetPostsSuccess() {
        self.content.text = self.hnStoriesTask.storyDetail["comments"]!.description
    }
    
    func onGetPostsError() {
        self.content.text = "Error"
        
        // Show error message
        let alertController = UIAlertController(title: "Ooops", message:
            "There was an error fetching the top stories. Please, try again later.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
