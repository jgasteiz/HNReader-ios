//
//  StoryDetailViewController.swift
//  HNReader
//
//  Created by Javi Manzano on 25/03/2015.
//  Copyright (c) 2015 Javi Manzano. All rights reserved.
//

import UIKit

class StoryDetailViewController: UIViewController {
    
    var storyTitle: String?
    var storyURL: NSURL?
    var storyId: Int?
    
    @IBOutlet weak var webView: UIWebView!

    @IBAction func shareStory(sender: UIBarButtonItem) {
        let objectsToShare = [storyURL!]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.barButtonItem = sender
        self.presentViewController(activityVC, animated: true, completion: nil)
    }

    @IBAction func openSafari(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(storyURL!)
    }
    
    
    @IBAction func viewComments(sender: AnyObject) {
        performSegueWithIdentifier("showComments", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showComments" {
            let controller = segue.destinationViewController as! StoryCommentsViewController
            controller.storyTitle = self.storyTitle
            controller.storyId = self.storyId
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

        self.navigationItem.title = storyTitle
        let request = NSURLRequest(URL: storyURL!)
        
        webView.scalesPageToFit = true
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
