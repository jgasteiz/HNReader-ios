//
//  StoryListVC.swift
//  HNReader
//
//  Created by Javi Manzano on 19/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import UIKit

class StoryListVC: UITableViewController {
    
    let reuseIdentifier = "StoryCell"
    
    var hnStoriesTask = HNStoriesTask()
    
    var lastUpdated: NSDate?
    
    var storyList: [Story] = []
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet weak var moreStoriesButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension

        // Initialize spinner
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0, 16, 16))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityIndicator)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let lastUpdated = lastUpdated {
            let now = NSDate()
            let difference = NSCalendar.currentCalendar().components(NSCalendarUnit.Second, fromDate: lastUpdated, toDate: now, options: [])
            
            // Don't update more than once per two minutes.
            if difference.second < 120 {
                return
            }
        }
        
        // Fetch the files and directories in the current directory.
        activityIndicator.startAnimating()
        hnStoriesTask.getTopStories(onStoriesLoadSuccess, onTaskError: onStoriesLoadError)
        lastUpdated = NSDate()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowStoryDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow as NSIndexPath! {
                let destinationVC = segue.destinationViewController as! StoryWebViewVC
                
                destinationVC.story = self.storyList[indexPath.row]
                destinationVC.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                destinationVC.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    @IBAction func moreStories (sender: AnyObject) {
        moreStoriesButton.enabled = false
        activityIndicator.startAnimating()
        hnStoriesTask.getNextThirtyStories(onStoriesLoadSuccess, onTaskError: onStoriesLoadError)
    }
    
    @IBAction func reloadStories (sender: AnyObject) {
        activityIndicator.startAnimating()
        hnStoriesTask.getTopStories(onStoriesLoadSuccess, onTaskError: onStoriesLoadError)
    }
    
    func onStoriesLoadSuccess(stories: [Story], firstThirtyStories: Bool) {
        activityIndicator.stopAnimating()
        
        // If the stories are the first thirty, load them as they come
        if firstThirtyStories == true {
            self.storyList = stories
            moreStoriesButton.enabled = true
        }
        // Otherwise, append them to the existing ones
        else {
            self.storyList = self.storyList + stories
            moreStoriesButton.enabled = false
        }
        
        tableView.reloadData()
    }
    
    func onStoriesLoadError() {
        activityIndicator.stopAnimating()
        
        self.storyList = []
        tableView.reloadData()
        
        // Show error message
        let alertController = UIAlertController(title: "Ooops", message:
            "There was an error fetching the top stories. Please, try again later.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension StoryListVC {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storyList.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Get the table cell
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! StoryCell
        
        // Retrieve the story with the cell index
        let story = self.storyList[indexPath.row]
        
        // Set the labels text with the story values
        cell.index.text = "\(indexPath.row + 1)"
        cell.title.text = story.getTitle()
        cell.url.text = story.getDisplayURL()
        cell.subtitle.text = "\(story.getPoints()) points"
        
        // If the story has a user, append it to the description label
        if story.hasUser() {
            cell.subtitle.text = "\(cell.subtitle.text!), by \(story.getUser())"
        }
        
        // No comment count until it's possible to view the comments in the app.
        cell.subtitle.text = "\(cell.subtitle.text!), \(story.getTimeAgo()), \(story.getCommentsCount()) comments"
        
        return cell
    }
}
