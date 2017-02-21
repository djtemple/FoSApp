//
//  HomeViewController.swift
//  fos
//
//  Created by Karson Chau on 2017-01-31.
//  Copyright © 2017 Karson Chau. All rights reserved.
//

import UIKit
import TwitterKit
import Alamofire

class HomeViewController: UIViewController, UITableViewDelegate, TWTRTweetViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tableView: UITableView!
    var imageArray = [UIImage]()
    
    let tweetTableReuseIdentifier = "TweetCell"

    // Hold all the loaded Tweets
    var tweets: [TWTRTweet] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    let tweetIDs = ["34937182"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageArray = [#imageLiteral(resourceName: "slide 1"), #imageLiteral(resourceName: "darwin_lecture_shoutout2017_2")]
        
        for i in 0..<imageArray.count {
            let iView = UIImageView()
            iView.image = imageArray[i]
            if i == 1 {
                iView.contentMode = .scaleAspectFit
            }
            else {
                iView.contentMode = .scaleAspectFit
            
            }
            let xPosition = self.view.frame.width * CGFloat(i)
            iView.frame = CGRect(x: xPosition, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            scrollView.addSubview(iView)
            
        }
        Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
        
        let client = TWTRAPIClient()
        let dataSource = TWTRUserTimelineDataSource.init(screenName: "UofC_Science", apiClient: client)
        
        tweets = dataSource.
        
        
        /*
        Alamofire.request("https://api.twitter.com/1.1/statuses/user_timeline.json?user_id=826142454613020672&screen_name=karson_chau").responseData(completionHandler: {
            response in
            self.parseData(JSONData: response.data!)
        
        })
        */
        // get the api key and response
        // put it into the function below
        
    }
    
    func parseData(JSONData: Data) {
        do {
            let readableJson = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! NSObject
            print(readableJson)
            tweets = TWTRTweet.tweets(withJSONArray: readableJson as? [Any]) as! [TWTRTweet]
        }
        catch {
            print(error)
        }
    }
    
    func moveToNextPage() {
        
        let pageWidth:CGFloat = self.scrollView.frame.width
        //print(pageWidth)
        let maxWidth:CGFloat = pageWidth * 2
        let contentOffset:CGFloat = self.scrollView.contentOffset.x
        //print(contentOffset)
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth
        {
            slideToX = 0
        }
 
        //self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
        
        self.scrollView.setContentOffset(CGPoint(x: slideToX, y: 0), animated: true)

    }
    // MARK: UITableViewDelegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: tweetTableReuseIdentifier, for: indexPath as IndexPath) as! TWTRTweetTableViewCell
        cell.tweetView.delegate = self
        cell.configure(with: tweet)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = tweets[indexPath.row]
        
        return TWTRTweetTableViewCell.height(for: tweet, style: .compact, width:self.view.bounds.width, showingActions: false)
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
