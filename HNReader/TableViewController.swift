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
    
    var items: [String] = ["We", "Heart", "Swift"]
    var storyList: [Story] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshPosts:")
        self.navigationItem.rightBarButtonItem = refreshButton

        initializeSpinner()
        
        refreshPosts(self)
    }
    
    func onGetPostsSuccess(stories: [Story]) {
        hideSpinner()
        storyList = stories
        println(storyList.count)
        tableView.reloadData()
    }
    
    func onGetPostsError() {
        // Do something here
    }
    
    func refreshPosts(sender: AnyObject) {
        storyList = []
        tableView.reloadData()
        showSpinner()
        hnFetchTask.getTopStories(onGetPostsSuccess, onTaskError: onGetPostsError)
    }
    
    func showSpinner() {
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
    }
    
    func hideSpinner() {
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
    }
    
    func initializeSpinner() {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.hidden = true
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storyList.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        let title = self.storyList[indexPath.row].title
        let author = self.storyList[indexPath.row].author!
        cell.textLabel?.text = "\(indexPath.row + 1) - \(title), by \(author)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("showDetail", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                
                let story: Story = self.storyList[indexPath.row]
                // let storyUrl = NSURL(string: story.url!)!

                let controller = (segue.destinationViewController as UINavigationController).topViewController as StoryDetailViewController
                
                controller.storyTitle = story.title
                controller.storyURL = NSURL(string: story.url!)
            }
        }
    }
}

