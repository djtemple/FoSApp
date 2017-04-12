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
    @IBOutlet weak var internetLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    var weblink:String? = nil
    
    var reachability = Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.loadAddress()
        self.activity.isHidden = true
        self.checkInternet()
    }
    
    func checkInternet() {
        
        if reachability?.currentReachabilityStatus == .notReachable {
            self.activity.isHidden = true
            self.activity.stopAnimating()
            self.internetLabel.isHidden = false
            self.tryAgainButton.isHidden = false
        }
        else {
            self.internetLabel.isHidden = true
            self.tryAgainButton.isHidden = true
            self.activity.isHidden = false
            self.loadAddress()
        }
    }
    
    func loadAddress() {
        let url:NSURL?
        
        self.activity.startAnimating()
        
        if weblink == nil {
            url = NSURL(string: "http://ucmapspro.ucalgary.ca/RoomFinder/")
        }
        else {
            url = NSURL(string: weblink!)
        }
        
        webView.loadRequest(NSURLRequest(url: url! as URL) as URLRequest)
    }
    /*
    func webViewDidStartLoad(_: UIWebView) {
        activity.startAnimating()
    }
    */
    func webViewDidFinishLoad(_:UIWebView) {
        activity.stopAnimating()
    }
    
    @IBAction func tryAgainButtonAction(_ sender: Any) {
        self.checkInternet()
        
    }


}
