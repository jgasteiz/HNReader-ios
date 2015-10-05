//
//  StoryDetailViewController.swift
//  HNReader
//
//  Created by Javi Manzano on 25/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import UIKit

class StoryCommentsController: UITableViewController {
    
    var hnStoriesTask = HNStoriesTask()
    
    var story: Story?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.title = self.story!.getTitle()
        
        fetchComments()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.story!.comments.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Get the table cell
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as UITableViewCell!
        
        let contentView: UIView = cell.viewWithTag(109) as UIView!
        let headerLabel: UILabel = cell.viewWithTag(110) as! UILabel
        let contentLabel: UILabel = cell.viewWithTag(111) as! UILabel
        
        // Retrieve the story with the cell index.
        let comment: Comment = self.story!.comments[indexPath.row]
        
        // Set the text for the header and the content.
        headerLabel.text = comment.getTextHeader()
        contentLabel.text = comment.getTextContent()
        
        // Update the leading constraints per comment.
        for constraint in contentView.constraints {
            if constraint.identifier == "leading" {
                constraint.constant = -CGFloat(comment.getLevel() * 15)
            }
        }
        
        return cell
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
