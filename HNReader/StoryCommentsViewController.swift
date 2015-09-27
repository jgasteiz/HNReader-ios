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
    
    @IBOutlet weak var commentsContent: UITextView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchComments() {
        hnStoriesTask.getComments(self.storyId!, onTaskDone: onGetPostsSuccess, onTaskError: onGetPostsError)
    }
    
    func onGetPostsSuccess(comments: [Comment]) {
        self.commentList = comments
        
        commentsContent.text = ""
        
        for (index, comment) in comments.enumerate() {
            commentsContent.text = "\(commentsContent.text)\(html2String(comment.getContent()))"
            
            // If it's not the last element, add two breaklines
            if index < comments.count - 1 {
                commentsContent.text = "\(commentsContent.text)\n\n"
            }
        }
    }
    
    func onGetPostsError() {
        // do something!
        
        // Show error message
        let alertController = UIAlertController(title: "Ooops", message:
            "There was an error fetching the top stories. Please, try again later.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //////////////
    // Helpers
    //////////////
    func html2String(html:String) -> String {
        return try! NSAttributedString(
            data: html.dataUsingEncoding(NSUTF8StringEncoding)!,
            options:[NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding],
            documentAttributes: nil).string
    }
}
