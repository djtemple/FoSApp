//
//  EventDetailViewController.swift
//  fos
//
//  Created by Karson Chau on 2017-03-24.
//  Copyright © 2017 Karson Chau. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var weblink:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //self.loadAddress()
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
        //activity.startAnimating()
        activity.startAnimating()
    }
    
    func webViewDidFinishLoad(_:UIWebView) {
        //activity.stopAnimating()
        
        activity.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
