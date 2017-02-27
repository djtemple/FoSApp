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
    
    // holds the struct of instagram post
    var instagram:[instagramPost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getTweets()
        self.getInstagramPost()
        
        self.tableView.reloadData()
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
    
    // low res: 320x320, thumbnail: 150x150, standard res: 640x640
    func parseData(JSONData: Data) {
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .allowFragments) as? [String:Any]
            //print(readableJSON ?? "no object")
            
            let datas = readableJSON?["data"] as? [[String:Any]]
            // loop through the data. If there is more than one instagram post from the user
            
            for data in datas! {
                //print(data)
                // checks if captions is not empty
                // cpations in JSON contain the text from the post, username, profile_picture, and created_time
                
                var text:String = ""
                var timeStamp:String = ""
                var username:String = ""
                var profileURL:String = ""
                var postURL:String = ""
                
                //var profileImage:UIImage = UIImage(named: "instagramProfile")!
                
                if let caption = data["caption"] as? [String: Any] {
                    
                    text = (caption["text"] as? String)!
                    //print(text ?? "text nil")
                    
                    timeStamp = (caption["created_time"] as? String)!
                    //print(timeStamp ?? "no created_time")
                    
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
                
                //let post:instagramPost = instagramPost(text: text, profileImageURL: profileURL, userName: username, timeStamp: timeStamp, profileImage: profileImage, postImage: #imageLiteral(resourceName: "cannot load image"))
                
                let post:instagramPost = instagramPost(text: text, profileImageURL: profileURL, postImageURL: postURL, userName: username, timeStamp: timeStamp)
                
                self.instagram.append(post)
            }
            
            print(self.instagram.count)
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
        return self.tweets.count + 1 + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == 0) {
            let scrollCell = tableView.dequeueReusableCell(withIdentifier: "ScrollCell", for: indexPath as IndexPath) as! ScrollTableViewCell
            return scrollCell
        }
            
        // this is hardcoded for only one instagram post
        else if (indexPath.row < (self.instagram.count + 1)) {
            let instaCell = tableView.dequeueReusableCell(withIdentifier: "InstagramCell", for: indexPath as IndexPath) as! InstagramTableViewCell
            instaCell.selectionStyle = UITableViewCellSelectionStyle.none
            
            
            // need some error checking to make sure instagram is not empty array
            
            if self.instagram.count > 0 {
                let post = self.instagram[indexPath.row - 1]
            
                instaCell.userNameLabel.text = post.userName
            
                // need to fill text from the post. Also need the cell to auto adjust height
                instaCell.textDescriptionLabel.text = post.text
                instaCell.textDescriptionLabel.numberOfLines = 0
            
                //instaCell.profileImage.image = post.profileImage
                
                instaCell.profileImage.sd_setImage(with: URL(string: post.profileImageURL))
                instaCell.postImage.sd_setImage(with: URL(string: post.postImageURL), placeholderImage: #imageLiteral(resourceName: "cannot load image"), options: [])
                
                
                //
                
                
                //instaCell.postImage.image = post.postImageURL
                
            }
            
            
            return instaCell
        }
        else {
            
            //let tweet = tweets[indexPath.row - self.instagram.count]
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath as IndexPath) as! TWTRTweetTableViewCell
            let index = indexPath.row - (1+self.instagram.count)
            
            if(index < self.tweets.count && (index > 0)) {
                let tweet = tweets[indexPath.row - 2]
                 cell.tweetView.delegate = self
                cell.tweetView.showActionButtons = false
                cell.configure(with: tweet)

                
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0 ) {
            return 130
        }
        else if (indexPath.row < (self.instagram.count + 1)) {
            // height for instagram post need to be auto sized
            return 515
        }
        else {
            let index = indexPath.row - (1+self.instagram.count)
            
            if(index < self.tweets.count && (index > 0)) {
                let tweet = tweets[indexPath.row - 2]
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
