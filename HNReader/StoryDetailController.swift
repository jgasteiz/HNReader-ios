//
//  StoryDetailViewController.swift
//  HNReader
//
//  Created by Javi Manzano on 25/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import UIKit

class StoryDetailController: UIViewController {
    
    var hnStoriesTask = HNStoriesTask()
    
    var story: Story?
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var bottomToolbar: UIToolbar!

    @IBAction func shareStory(sender: UIBarButtonItem) {
        let objectsToShare = [NSURL(string: self.story!.getURL())!]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.barButtonItem = sender
        self.presentViewController(activityVC, animated: true, completion: nil)
    }

    @IBAction func openSafari(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: self.story!.getURL())!)
    }
    
    
    @IBAction func viewComments(sender: AnyObject) {
        performSegueWithIdentifier("showComments", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showComments" {
            let controller = segue.destinationViewController as! StoryDetailCommentsController
            controller.story = self.story!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

        self.navigationItem.title = self.story!.getTitle()
        
        if self.story!.getURL() != "" {
            let request = NSURLRequest(URL: NSURL(string: self.story!.getURL())!)
            self.webView.scalesPageToFit = true
            self.webView.loadRequest(request)
        } else {
            // Load story content
            self.fetchStory()
            self.bottomToolbar.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchStory() {
        self.hnStoriesTask.getStoryDetail(self.story!.getId(), onTaskDone: onGetStorySuccess, onTaskError: onGetPostsError)
    }
    
    func onGetStorySuccess(story: Story) {
        self.story = story
        self.webView.loadHTMLString(self.story!.getHTMLContent() as String!, baseURL: nil)
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
