//
//  StoryDetailViewController.swift
//  HNReader
//
//  Created by Javi Manzano on 25/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import UIKit

class StoryCommentsController: UITableViewController {
    
    let reuseIdentifier = "CommentCell"
    
    var hnStoriesTask = HNStoriesTask()
    
    var story: Story?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.title = self.story!.getTitle()
        
        fetchComments()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchComments() {
        hnStoriesTask.getStoryComments(self.story!.getId(), onTaskDone: onGetCommentsSuccess, onTaskError: onGetPostsError)
    }
    
    func onGetCommentsSuccess(comments: [Comment]) {
        self.story!.comments = comments
        tableView.reloadData()
    }
    
    func onGetPostsError() {
        // Show error message
        let alertController = UIAlertController(title: "Ooops", message:
            "There was an error fetching the top stories. Please, try again later.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension StoryCommentsController {
    
    override func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        return self.story!.comments[indexPath.row].getLevel()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.story!.comments.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Get the table cell
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)  as! StoryCommentCell
        
        // Retrieve the comment
        let comment: Comment = self.story!.comments[indexPath.row]
        
        // Set the text for the header and the content.
        cell.header.text = comment.getTextHeader()
        cell.content.text = comment.getTextContent()
        
        return cell
    }
}