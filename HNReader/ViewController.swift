//
//  ViewController.swift
//  HNReader
//
//  Created by Javi Manzano on 19/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var hnFetchTask = HNFetchTask()
    
    var items: [String] = ["We", "Heart", "Swift"]
    var storyList: [String] = []
    var debouncedTableReload = {() -> () in
        print("Not implemented yet")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.debouncedTableReload = hnFetchTask.debounce(
            NSTimeInterval(1),
            queue: dispatch_get_main_queue(),
            reloadTable
        )
        
        hnFetchTask.getTopStories(onGetPostsSuccess, onTaskError: onGetPostsError)
    }
    
    func onGetPostsSuccess(stories: [Story]) {
        
        storyList = []
        for (index, story) in enumerate(stories) {
            let storyTitle = "\(index + 1) - \(story.title!), by \(story.author!)"
            storyList.append(storyTitle)
        }
        debouncedTableReload()
    }
    
    func reloadTable() {
        println("RELOADING THE TABLE")
        tableView.reloadData()
    }
    
    func onGetPostsError() {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storyList.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        cell.textLabel?.text = self.storyList[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

