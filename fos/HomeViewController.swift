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

struct instagramPost {
    
    var text: String
    var profileImageURL: String
    var postImageURL:String
    var userName: String
    var timeStamp:String
}


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,TWTRTweetViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var imageArray = [UIImage]()
    // Hold all the loaded Tweets
    var tweets: [TWTRTweet] = []
    var instagram:[instagramPost] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hides the nav bar when scrolling
        //navigationController?.hidesBarsOnSwipe = true
        
        self.tableView.alwaysBounceVertical = false

        
        self.getInstagramPost()
        
        self.getTweets()
    }
    
    func getInstagramPost() {
        // access token is at the end of the url string
        // not sure if the access token will expire and ask for a new one.
        // access token tutorial from here: http://jelled.com/instagram/access-token
        let url = "https://api.instagram.com/v1/users/self/media/recent/?access_token=4705337461.36b725b.9adf55032d094167a3984ce6b0c3a315"
        
        //let url = "https://www.instagram.com/ucwearescience/media/"
        Alamofire.request(url).responseJSON { (response) in
            self.parseData(JSONData: response.data!)
        }
    }
    
    func parseData(JSONData: Data) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .allowFragments) as? NSDictionary
            // readableJSON contains the instagram post
            
            // prints the readable JSON to parse
            // here is a link if you want to see the JSON response as well:
            //https://apigee.com/console/instagram?req=%7B%22resource%22%3A%22%22%2C%22params%22%3A%7B%22query%22%3A%7B%7D%2C%22template%22%3A%7B%7D%2C%22headers%22%3A%7B%7D%2C%22body%22%3A%7B%22attachmentFormat%22%3A%22mime%22%2C%22attachmentContentDisposition%22%3A%22form-data%22%7D%7D%2C%22verb%22%3A%22get%22%7D
            //print(readableJSON ?? "no object")
            
            let datas = readableJSON?["data"] as? [[String:Any]]
            
            for data in datas! {
                //print(data)
                // checks if captions is not empty
                // cpations in JSON contain the text from the post, username, profile_picture, and created_time
                
                var text:String = ""
                var timeStamp:String = ""
                var username:String = ""
                var profileURL:String = ""
                var postURL:String = ""
                
                if let caption = data["caption"] as? [String: Any] {
                    
                    text = (caption["text"] as? String)!
                    //print(text ?? "text nil")
                    
                    let createdTime = (caption["created_time"] as? String)!
                    //print(timeStamp ?? "no created_time")
                    
                    let date = NSDate(timeIntervalSince1970: Double(createdTime)!)
                    let dateFormatter = DateFormatter()
                    //dateFormatter.timeStyle = DateFormatter.Style.medium
                    //dateFormatter.dateStyle = DateFormatter.Style.short
                    dateFormatter.dateFormat = "E MMM DD HH:mm y"
                    timeStamp = dateFormatter.string(from: date as Date)
                    
                    //print(timeStamp)
                    
                    // check to see if from is not empty
                    if let from = caption["from"] as? [String: Any] {
                        profileURL = (from["profile_picture"] as? String)!
                        //print(profileImage ?? "profile_iamge == nil")
                        username = (from["username"] as? String)!
                        //print(username ?? "username is nil")
                    }
                }
                
                if let image = data["images"] as? [String:Any] {
                    //print(image)
                    if let std_Res = image["standard_resolution"] as? [String:Any] {
                        postURL = (std_Res["url"] as? String)!
                    }
                    
                }
                
                //let post:instagramPost = instagramPost(text: text, profileImageURL: profileURL, userName: username, timeStamp: timeStamp, profileImage:#imageLiteral(resourceName: "instagramProfile"), postImage: #imageLiteral(resourceName: "cannot load image"))
                let post:instagramPost = instagramPost(text: text, profileImageURL: profileURL, postImageURL: postURL, userName: username, timeStamp: timeStamp)
                
                
                self.instagram.append(post)
                
                
                
                
            }
            //print(self.instagram)
            
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
        
        twitter?.getHomeTimeline(sinceID: nil, count: 40, successBlock: { (statuses) in
            //print(statuses!)
            
            self.tweets = TWTRTweet.tweets(withJSONArray: statuses!) as! [TWTRTweet]
            
            //print(self.tweets)
            
            self.tableView.reloadData()
            
        }) { (error) in
            print(error ?? "Error fetching data")
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Plus one for the header cell
        //return self.tweets.count + 1
        
        
        return self.tweets.count + self.instagram.count + 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == 0) {
            let scrollCell = tableView.dequeueReusableCell(withIdentifier: "ScrollCell", for: indexPath as IndexPath) as! ScrollTableViewCell
            return scrollCell
        }
            
        else if (indexPath.row < (self.instagram.count + 1)) {
            let instaCell = tableView.dequeueReusableCell(withIdentifier: "InstagramCell", for: indexPath as IndexPath) as! InstagramPostTableViewCell
            instaCell.selectionStyle = UITableViewCellSelectionStyle.none
            
            
            // need some error checking to make sure instagram is not empty array
            
            if self.instagram.count > 0 {
                let post = self.instagram[indexPath.row - 1]
                
                instaCell.userNameLabel.text = post.userName
                
                
                instaCell.profileImage.sd_setImage(with: URL(string: post.profileImageURL))
                instaCell.postImage.sd_setImage(with: URL(string: post.postImageURL), placeholderImage: #imageLiteral(resourceName: "cannot load image"), options: [])
                
                // need to fill text from the post. Also need the cell to auto adjust height
                
                instaCell.postTextLabel.text? = post.text
                //instaCell.postTextLabel.numberOfLines = 6
                instaCell.postTextLabel.adjustsFontSizeToFitWidth = false
                instaCell.postTextLabel.lineBreakMode = .byTruncatingTail
                
            }
            
            
            return instaCell
        }
            
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath as IndexPath) as! TWTRTweetTableViewCell
            
            let index = indexPath.row - (1+self.instagram.count)
            
            if(index < self.tweets.count && (index > 0)) {
                let tweet = tweets[index]
                cell.tweetView.delegate = self
                cell.tweetView.showActionButtons = false
                cell.configure(with: tweet)
                
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // height for header
        if(indexPath.row == 0){
            return 120
        }
            
            // height for instagram cells
        else if (indexPath.row < (self.instagram.count + 1)) {
            return 475
        }
            
            // height for twitter cells
        else {
            let index = indexPath.row - (1+self.instagram.count)
            
            if(index < self.tweets.count && (index > 0)) {
                let tweet = tweets[index]
                return TWTRTweetTableViewCell.height(for: tweet, style: .compact, width: self.view.bounds.width, showingActions: false)
            }
            else {
                return 0
            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "ShowInstagram") {
            
            let view:InstagramTableViewController = (segue.destination as? InstagramTableViewController)!
    
            if let selectedPost = sender as? InstagramPostTableViewCell {
                let indexPath = tableView.indexPath(for: selectedPost)!
                let expandedPost = self.instagram[indexPath.row - 1]
                view.post = expandedPost
                
            }
            
        }
 
    }
    
    
}
