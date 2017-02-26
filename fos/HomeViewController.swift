//
//  HomeViewController.swift
//  fos
//
//  Created by Karson Chau on 2017-01-31.
//  Copyright © 2017 Karson Chau. All rights reserved.
//

import UIKit
import TwitterKit
import STTwitter
import Alamofire

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,TWTRTweetViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var imageArray = [UIImage]()
    // Hold all the loaded Tweets
    var tweets: [TWTRTweet] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getTweets()
        self.getInstagramPost()
        
    }
    
    func getInstagramPost() {
        // access token is at the end of the url string
        // not sure if the access token will expire and ask for a new one.
        // access token tutorial from here: http://jelled.com/instagram/access-token
        let url = "https://api.instagram.com/v1/users/self/media/recent/?access_token=4705337461.36b725b.9adf55032d094167a3984ce6b0c3a315"
        Alamofire.request(url).responseJSON { (response) in
            self.parseData(JSONData: response.data!)
        }
    }
    
    func parseData(JSONData: Data) {
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .allowFragments) as? NSDictionary
            // readableJSON contains the instagram post
            
            // prints the readable JSON to parse 
            // here is a link if you want to see the JSON response as well:
            //https://apigee.com/console/instagram?req=%7B%22resource%22%3A%22%22%2C%22params%22%3A%7B%22query%22%3A%7B%7D%2C%22template%22%3A%7B%7D%2C%22headers%22%3A%7B%7D%2C%22body%22%3A%7B%22attachmentFormat%22%3A%22mime%22%2C%22attachmentContentDisposition%22%3A%22form-data%22%7D%7D%2C%22verb%22%3A%22get%22%7D
            print(readableJSON ?? "no object")
        }
        catch {
            print(error)
        }
    }
    
    func getTweets() {
        let twitter = STTwitterAPI(oAuthConsumerKey: "vGdyaBeBYWka2JwDQvHSLviCL", consumerSecret: "OTcbCMM9oW9D3wXVDp6gTpwkzRQzDBfDgm9AXfipLjH3pq0C0t", oauthToken: "826142454613020672-cRBbVSOOPhNBstNnPDin6NJl3swd8Wp", oauthTokenSecret: "yWmRoRJBb9oPx00od1FpUCzfS6XC48uxUJa9si85d2ryo")
        
        twitter?.verifyCredentials(userSuccessBlock: { (username, userID) in
            
            //print(username!)
            
        }) { (error) in
            
            print(error ?? "Error verifing")
            
        }
        
        twitter?.getHomeTimeline(sinceID: nil, count: 20, successBlock: { (statuses) in
            //print(statuses!)
            
            self.tweets = TWTRTweet.tweets(withJSONArray: statuses!) as! [TWTRTweet]
            
            //print(self.tweets)
            
            self.tableView.reloadData()
            
        }) { (error) in
            print(error ?? "Error fetching data")
        }
        

    }
    
    
    
    
    // MARK: UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Plus one for the header cell
        return self.tweets.count + 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == 0) {
            let scrollCell = tableView.dequeueReusableCell(withIdentifier: "ScrollCell", for: indexPath as IndexPath) as! ScrollTableViewCell
            return scrollCell
        }
        else {
            let tweet = tweets[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath as IndexPath) as! TWTRTweetTableViewCell
            cell.tweetView.delegate = self
            cell.tweetView.showActionButtons = false
            cell.configure(with: tweet)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.row > 0) {
            let tweet = tweets[indexPath.row - 1]
            
            return TWTRTweetTableViewCell.height(for: tweet, style: .compact, width:self.view.bounds.width, showingActions: false)
        }
        else {
            return 120
            
        }
        
    }
    
    
    // leave it for now. This gets rid of the tweet actions in twttweetdetailviewcontroller
    func tweetView(_ tweetView: TWTRTweetView, shouldDisplay controller: TWTRTweetDetailViewController) -> Bool {
        // customize the controller to fit your needs.
        
        // show the view controller in a way that is appropriate for you current setup which may include pushing on a
        // navigation stack or presenting in a pop over controller.
        self.show(controller, sender:self)
        
        // return false to tell Twitter Kit that you will present the controller on your own.
        // return true if you want Twitter Kit to present it for you, this is the default if you don't implement this method.
        return false;
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
