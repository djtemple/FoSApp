//
//  ResourceViewController.swift
//  fos
//
//  Created by Karson Chau on 2017-03-18.
//  Copyright © 2017 Karson Chau. All rights reserved.
//

import UIKit

class ResourceViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var weblink:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadAddress()
    }
    
    func loadAddress() {
        let url:NSURL?
        
        if weblink == nil {
            url = NSURL(string: "http://ucmapspro.ucalgary.ca/RoomFinder/")
        }
        else {
            url = NSURL(string: weblink!)
        }
        
        webView.loadRequest(NSURLRequest(url: url! as URL) as URLRequest)
    }
    
    func webViewDidStartLoad(_: UIWebView) {
        activity.startAnimating()
    }
    
    func webViewDidFinishLoad(_:UIWebView) {
        activity.stopAnimating()
    }
    


}
