//
//  ViewController.swift
//  HNReader
//
//  Created by Javi Manzano on 19/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import UIKit

class StoryListController: UITableViewController {
    
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
        
        // Force touch feature
        if #available(iOS 9.0, *) {
            if traitCollection.forceTouchCapability == UIForceTouchCapability.Available {
                // register UIViewControllerPreviewingDelegate to enable Peek & Pop
                registerForPreviewingWithDelegate(self, sourceView: view)
            }
        }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow as NSIndexPath! {
                
                let story: Story = self.storyList[indexPath.row]

                let controller = segue.destinationViewController as! StoryController
                
                controller.story = story
            }
        } else if segue.identifier == "showComments" {
            let button = sender as! UIButton
            let story: Story = self.storyList[button.tag]
            let controller = segue.destinationViewController as! StoryCommentsController
            controller.story = story
        }
    }
    
    @IBAction func moreStories(sender: AnyObject) {
        moreStoriesButton.enabled = false
        activityIndicator.startAnimating()
        hnStoriesTask.getNextThirtyStories(onStoriesLoadSuccess, onTaskError: onStoriesLoadError)
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

extension StoryListController {
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


extension StoryListController : UIViewControllerPreviewingDelegate {
    
    func previewingContext(previewingContext: UIViewControllerPreviewing,viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        // Obtain the index path and the cell that was pressed.
        guard let indexPath = tableView.indexPathForRowAtPoint(location),
            cell = tableView.cellForRowAtIndexPath(indexPath) else { return nil }
        
        // Create a destination view controller and set its properties.
        guard let destinationViewController = storyboard?.instantiateViewControllerWithIdentifier("StoryController") as? StoryController else { return nil }
        let story: Story = self.storyList[indexPath.row]
        destinationViewController.story = story
        
        /*
        Set the height of the preview by setting the preferred content size of the destination view controller. Height: 0.0 to get default height
        */
        destinationViewController.preferredContentSize = CGSize(width: 0.0, height: 0.0)
        
        if #available(iOS 9.0, *) {
            previewingContext.sourceRect = cell.frame
        }
        
        return destinationViewController
    }
    
    /// Called to let you prepare the presentation of a commit (Pop).
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        // Presents viewControllerToCommit in a primary context
        showViewController(viewControllerToCommit, sender: self)
    }
}

