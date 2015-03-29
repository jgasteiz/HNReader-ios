//
//  ViewController.swift
//  HNReader
//
//  Created by Javi Manzano on 19/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var hnFetchTask = HNFetchTask()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var refreshButton: UIBarButtonItem?
    
    var items: [String] = ["We", "Heart", "Swift"]
    var storyList: [Story] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        // Initialize refresh button
        refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshPosts:")
        self.navigationItem.rightBarButtonItem = refreshButton!

        // Initialize spinner
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0, 16, 16))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        activityIndicator.hidden = true
        
        refreshPosts(self)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storyList.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("StoryCell") as UITableViewCell
        
        var indexLabel: UILabel = cell.viewWithTag(110) as UILabel!
        var titleLabel: UILabel = cell.viewWithTag(111) as UILabel!
        var urlLabel: UILabel = cell.viewWithTag(112) as UILabel!
        var descriptionLabel: UILabel = cell.viewWithTag(113) as UILabel!
        
        let title = self.storyList[indexPath.row].title
        let author = self.storyList[indexPath.row].author
        let score = self.storyList[indexPath.row].score
        var url = self.storyList[indexPath.row].getURL()

        indexLabel.text = "\(indexPath.row + 1)"
        titleLabel.text = title
        urlLabel.text = url
        descriptionLabel.text = "\(score) points, by \(author)"
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                
                let story: Story = self.storyList[indexPath.row]

                let controller = segue.destinationViewController as StoryDetailViewController
                
                controller.storyTitle = story.title
                controller.storyURL = NSURL(string: story.getURL())
            }
        }
    }
    
    func onGetPostsSuccess(stories: [Story]) {
        hideSpinner()
        
        storyList = stories
        tableView.reloadData()
    }
    
    func onGetPostsError() {
        // Do something here
    }

    func showSpinner() {
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
    }

    func hideSpinner() {
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
        self.navigationItem.rightBarButtonItem = refreshButton!
    }
    
    func refreshPosts(sender: AnyObject) {
        showSpinner()
        
        storyList = []
        tableView.reloadData()
        hnFetchTask.getTopStories(onGetPostsSuccess, onTaskError: onGetPostsError)
    }
}

