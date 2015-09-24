//
//  ViewController.swift
//  HNReader
//
//  Created by Javi Manzano on 19/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var hnStoriesTask = HNStoriesTask()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var refreshButton: UIBarButtonItem!

    var storyList: [Story] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        // Initialize spinner
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0, 16, 16))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        refreshPosts(self)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storyList.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Get the table cell
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("StoryCell") as UITableViewCell!
        
        // Get the labels to fill
        let indexLabel: UILabel = cell.viewWithTag(110) as! UILabel
        let titleLabel: UILabel = cell.viewWithTag(111) as! UILabel
        let urlLabel: UILabel = cell.viewWithTag(112) as! UILabel
        let descriptionLabel: UILabel = cell.viewWithTag(113) as! UILabel
        
        // Retrieve the story with the cell index
        let story = self.storyList[indexPath.row]

        // Set the labels text with the story values
        indexLabel.text = "\(indexPath.row + 1)"
        titleLabel.text = story.getTitle()
        urlLabel.text = story.getURL()
        descriptionLabel.text = "\(story.getPoints()) points"
        
        // If the story has a user, append it to the description label
        if story.hasUser() {
            descriptionLabel.text = "\(descriptionLabel.text!), by \(story.getUser())"
        }
        
        // No comment count until it's possible to view the comments in the app.
        // descriptionLabel.text = "\(descriptionLabel.text!), \(story.getTimeAgo()) - \(story.getCommentsCount()) comments"
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow as NSIndexPath! {
                
                let story: Story = self.storyList[indexPath.row]

                let controller = segue.destinationViewController as! StoryDetailViewController
                
                controller.storyTitle = story.getTitle()
                controller.storyURL = NSURL(string: story.getURL())
            }
        }
    }

    @IBAction func refreshPosts(sender: AnyObject) {
        activityIndicator.startAnimating()
        hnStoriesTask.getTopStories(onGetPostsSuccess, onTaskError: onGetPostsError)
    }
    
    func onGetPostsSuccess() {
        activityIndicator.stopAnimating()
        
        storyList = self.hnStoriesTask.storiesArray
        tableView.reloadData()
    }
    
    func onGetPostsError() {
        activityIndicator.stopAnimating()
        
        storyList = []
        tableView.reloadData()
        
        // Show error message
        let alertController = UIAlertController(title: "Ooops", message:
            "There was an error fetching the top stories. Please, try again later.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

