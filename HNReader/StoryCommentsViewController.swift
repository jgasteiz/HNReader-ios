//
//  StoryDetailViewController.swift
//  HNReader
//
//  Created by Javi Manzano on 25/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import UIKit

class StoryCommentsViewController: UITableViewController {
    
    var hnStoriesTask = HNStoriesTask()
    
    var commentList: NSArray = NSArray()
    
    var storyTitle: String?
    var storyId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        self.navigationItem.title = self.storyTitle
        
        fetchComments()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentList.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Get the table cell
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as UITableViewCell!
        
        // Retrieve the story with the cell index
        let comment = self.commentList[indexPath.row] as! NSDictionary
        let commentText = (comment["content"] as! String).html2String
        
        // Get the labels to fill
        let commentLabel: UILabel = cell.viewWithTag(110) as! UILabel
        commentLabel.text = commentText
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as UITableViewCell!
        let commentLabel: UILabel = cell.viewWithTag(110) as! UILabel
        let comment = self.commentList[indexPath.row] as! NSDictionary
        let commentText = (comment["content"] as! String).html2String
        
        return heightForView(commentText, font: commentLabel.font, width: cell.frame.width)
    }
    
    func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func fetchComments() {
        hnStoriesTask.getStory(self.storyId!, onTaskDone: onGetPostsSuccess, onTaskError: onGetPostsError)
    }
    
    func onGetPostsSuccess() {
        self.commentList = self.hnStoriesTask.storyDetail["comments"] as! NSArray
        tableView.reloadData()
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
