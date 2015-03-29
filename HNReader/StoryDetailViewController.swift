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
    
    @IBOutlet weak var webView: UIWebView!
    
    func configureView() {
        // Update the user interface for the detail item.
        self.navigationItem.title = storyTitle
        let request = NSURLRequest(URL: storyURL!)
        webView.loadRequest(request)
    }
    
    func shareStory(sender: UIButton) {
        let objectsToShare = [storyURL!]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = sender
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

        let shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareStory:")
        self.navigationItem.rightBarButtonItem = shareButton

        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
