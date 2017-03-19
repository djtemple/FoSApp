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
    var weblink:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(weblink ?? nil)
        
        let url:NSURL?
        
        if weblink == nil {
            url = NSURL(string: "http://ucmapspro.ucalgary.ca/RoomFinder/")
        }
        else {
            url = NSURL(string: weblink!)
        }
        
        webView.loadRequest(NSURLRequest(url: url! as URL) as URLRequest)
        
        // Do any additional setup after loading the view.
    }
    


}
