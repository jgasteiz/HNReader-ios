//
//  .swift
//  HNReader
//
//  Created by Javi Manzano on 25/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import UIKit

class StoryWebViewVC: UIViewController {
    
    var hnStoriesTask = HNStoriesTask()
    
    var story: Story?
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false

        if let story = story {
            navigationItem.title = story.getTitle()
            
            if story.getURL() != "" {
                if let storyNSURL = NSURL(string: story.getURL()) {
                    let request = NSURLRequest(URL: storyNSURL)
                    webView.scalesPageToFit = true
                    webView.loadRequest(request)
                }
            } else {
                // Load story content
                fetchStory()
                bottomToolbar.hidden = true
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowStoryComments" {
            let destinationVC = segue.destinationViewController as! StoryCommentsVC
            destinationVC.story = story
        }
    }

    @IBAction func shareStory(sender: UIBarButtonItem) {
        let objectsToShare = [NSURL(string: story!.getURL())!]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.barButtonItem = sender
        presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func openSafari(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: story!.getURL())!)
    }
    
    
    @IBAction func viewComments(sender: AnyObject) {
        performSegueWithIdentifier("showComments", sender: self)
    }
    
    func fetchStory() {
        hnStoriesTask.getStoryDetail(story!.getId(), onTaskDone: onGetStorySuccess, onTaskError: onGetPostsError)
    }
    
    func onGetStorySuccess(story: Story) {
        self.story = story
        self.webView.loadHTMLString(story.getHTML() as String!, baseURL: nil)
    }
    
    func onGetPostsError() {
        // Show error message
        let alertController = UIAlertController(title: "Ooops", message:
            "There was an error fetching the top stories. Please, try again later.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}
