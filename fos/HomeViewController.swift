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


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,TWTRTweetViewDelegate, UITabBarControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var noInternetLabel: UILabel!
    
    @IBOutlet weak var tryAgainButton: UIButton!
    var imageArray = [UIImage]()
    
    // Hold all the loaded Tweets
    var tweets: [TWTRTweet] = []
    var instagram:[instagramPost] = []
    
    var postArray:[Any] = []
    
    var refreshControl = UIRefreshControl()
    
    var reachability = Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hides the nav bar when scrolling
        //navigationController?.hidesBarsOnSwipe = true
        
        // set the delegate of the tab bar
        self.tabBarController?.delegate = self
        
        self.tableView.tableHeaderView = nil
        
        self.tableView.estimatedRowHeight = 400
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.alwaysBounceVertical = false
        
        self.tableView.scrollsToTop = true
        
        
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(HomeViewController.refresh(sender:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
        
        
        
        self.checkInternet()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        // check internet connection
        
        // but do you have to reload the data if the data is already there?
    }
    
    func checkInternet() {
        if reachability?.currentReachabilityStatus == .notReachable {
            print("No internet connection")
            self.tryAgainButton.isHidden = false
            self.noInternetLabel.isHidden = false
            self.activityIndicator.isHidden = true
            
        }
        else {
            print("Internet connection avaible")
            self.noInternetLabel.isHidden = true
            self.tryAgainButton.isHidden = true
            
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
            
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                self.getInstagramPost()
                
                // Bounce back to the main thread to update the UI
                DispatchQueue.main.async {
                    
                }
            }
            
        }

    }
    
    
    // scroll tableview to the top when the home tab bar is selected
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("in home 0")

        if tabBarController.selectedIndex == 0 {
            print("------ home is 0")
            if !self.postArray.isEmpty {
                self.scrollToFirstRow()
            }
            
        }
        else if tabBarController.selectedIndex == 2 {
            //EventsViewController.scr
            print("--- home is 2")
            
            if viewController is UINavigationController {
                print("view is a navigation")
                               
            }
        }
        
        
    }
    
    
    func didLoad() {
        let defaults = UserDefaults.standard
        
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
        
        if defaults.bool(forKey: "All") {
            //self.postArray = self.instagram
            self.sortArray()
        }
            
        else if defaults.bool(forKey: "Instagram") {
            self.postArray = self.instagram
        }
        else if defaults.bool(forKey: "Twitter") {
            self.postArray = self.tweets
        }
        if self.activityIndicator.isAnimating {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        
        self.tableView.reloadData()
        self.scrollToFirstRow()
    }
    
    func refresh(sender: AnyObject) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.getInstagramPost()
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // Scroll the tableview back to display the first table cell
    func scrollToFirstRow() {
        
        if !postArray.isEmpty {
            let indexPath = NSIndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)

        }
    }
    
    func getInstagramPost() {
        // access token is at the end of the url string
        // not sure if the access token will expire and ask for a new one.
        // access token tutorial from here: http://jelled.com/instagram/access-token
        let url = "https://api.instagram.com/v1/users/self/media/recent/?access_token=4705337461.36b725b.9adf55032d094167a3984ce6b0c3a315"
        
        print("In getInstagramPost")
        
        //let url = "https://www.instagram.com/ucwearescience/media/"
        Alamofire.request(url).responseJSON { (response) in
            self.parseData(JSONData: response.data!) { () -> () in
                print("Done Instagram")}
            
            self.getTweets()
            //self.sortArray()
        }
        
    }
    
    func parseData(JSONData: Data, completion: () -> ()) {
        //print("In parseData")
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .allowFragments) as? NSDictionary
            // readableJSON contains the instagram post
            
            // here is a link if you want to see the JSON response as well:
            //https://apigee.com/console/instagram?req=%7B%22resource%22%3A%22%22%2C%22params%22%3A%7B%22query%22%3A%7B%7D%2C%22template%22%3A%7B%7D%2C%22headers%22%3A%7B%7D%2C%22body%22%3A%7B%22attachmentFormat%22%3A%22mime%22%2C%22attachmentContentDisposition%22%3A%22form-data%22%7D%7D%2C%22verb%22%3A%22get%22%7D
            //print(readableJSON ?? "no object")
            
            let datas = readableJSON?["data"] as? [[String:Any]]
            
            
            if self.instagram.count > 0 {
                self.instagram = []
            }
            
            for data in datas! {
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
                    //print(createdTime ?? "no created_time")
                    
                    let date = NSDate(timeIntervalSince1970: Double(createdTime)!)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-d HH:mm:ssZ"
                    timeStamp = dateFormatter.string(from: date as Date)
                    
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
                
                let post:instagramPost = instagramPost(text: text, profileImageURL: profileURL, postImageURL: postURL, userName: username, timeStamp: timeStamp)
                
                self.instagram.append(post)
            }
        }
        catch {
            print(error)
        }
        completion()
    }
    
    /*
     * gets the tweets from the keys
     * after getting the tweets in a json array. It uses TWTRTweets from Fabric to convert the json into a TWTRTweet array
     */
    func getTweets() {
        //print("In getTweets")
        let twitter = STTwitterAPI(oAuthConsumerKey: "vGdyaBeBYWka2JwDQvHSLviCL", consumerSecret: "OTcbCMM9oW9D3wXVDp6gTpwkzRQzDBfDgm9AXfipLjH3pq0C0t", oauthToken: "826142454613020672-cRBbVSOOPhNBstNnPDin6NJl3swd8Wp", oauthTokenSecret: "yWmRoRJBb9oPx00od1FpUCzfS6XC48uxUJa9si85d2ryo")
        
        twitter?.verifyCredentials(userSuccessBlock: { (username, userID) in
            
            //print(username!)
            
        }) { (error) in
            
            print(error ?? "Error verifing")
            
        }
        twitter?.getHomeTimeline(sinceID: nil, count: 800, successBlock: { (statuses) in
            //print(statuses!)
            
            self.tweets = TWTRTweet.tweets(withJSONArray: statuses!) as! [TWTRTweet]
            self.didLoad()
            
        }) { (error) in
            print(error ?? "Error fetching data")
        }
        
    }
    
    /* Sorts the instagram post and twitter post into one timeline.
     * Organizes the post from dates (newest to oldest)
     */
    func sortArray() {
        let limit = self.instagram.count + self.tweets.count
        
        if self.postArray.count == limit {
            return
        }
        else {
            self.postArray = []
        }
        
        var instagramIndex = 0
        var tweetIndex = 0
        
        var instagramLast = false
        var twitterLast = false
        
        for _ in 0..<limit {
            let instaPost = self.instagram[instagramIndex]
            let tweet = self.tweets[tweetIndex]
            
            // format the date formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-d HH:mm:ssZ"
            
            let instagramDate = dateFormatter.date(from: instaPost.timeStamp)
            let twtDate = tweet.createdAt
            
            if twtDate > instagramDate! {
                // twitter first 
                
                if !twitterLast {
                    self.postArray.append(tweet)
                    
                    if tweetIndex + 1 < self.tweets.count {
                        tweetIndex += 1
                    }
                    
                    if tweet == self.tweets.last {
                        twitterLast = true
                    }
                }
                else {
                    // last tweet in the post array already
                    if !instagramLast {
                        self.postArray.append(instaPost)
                        
                        if instagramIndex + 1 < self.instagram.count {
                            instagramIndex += 1
                        }
                        
                        if instaPost.text.lowercased() == self.instagram[instagramIndex].text.lowercased(){
                            instagramLast = true
                        }
                    }
                }
            }
            else {
                // instagram before twitter
                if !instagramLast {
                    self.postArray.append(instaPost)
                    
                    if instagramIndex + 1 < self.instagram.count {
                        instagramIndex += 1
                    }
                    if instaPost.text.lowercased() == self.instagram[instagramIndex].text.lowercased() {
                        instagramLast = true
                    }
                }
                else {
                    if !twitterLast {
                        self.postArray.append(tweet)
                        
                        if tweetIndex + 1 < self.tweets.count {
                            tweetIndex += 1
                        }
                        
                        if tweet == self.tweets.last {
                            twitterLast = true
                        }

                    }
                }
            }
            
            
            
        }
        // after processing the postArray. Reload the table view data
        self.tableView.reloadData()
    }
    
    //return the number of cells from the postArray count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.postArray.count + 1
        
    }
    
    // configures the tableview cell from the post
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScrollCell", for: indexPath) as! ScrollTableViewCell
            return  cell
        }
        else {
            // check of the index path is with the postArray length
            
            if (indexPath.row >= 1) {
                
                // get the post from the array
                let post = self.postArray[indexPath.row - 1]
                
                // check if it is an instagram post
                if post is instagramPost {
                    
                    // return a instagram cell from the instagram post
                    let instaPost = post as! instagramPost
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "InstagramCell", for: indexPath as IndexPath) as! InstagramPostTableViewCell
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell.userNameLabel.text = instaPost.userName
                    
                    //cell.profileImage.sd_setImage(with: URL(string: instaPost.profileImageURL))
                    cell.profileImage.sd_setImage(with: URL(string: instaPost.profileImageURL), placeholderImage: #imageLiteral(resourceName: "instagramProfileImage"), options: [])
                    cell.postImage.sd_setImage(with: URL(string: instaPost.postImageURL), placeholderImage: #imageLiteral(resourceName: "cannot load image"), options: [])
                    
                    cell.postTextLabel.text? = instaPost.text
                    //cell.postTextLabel.numberOfLines = 6
                    cell.postTextLabel.adjustsFontSizeToFitWidth = false
                    cell.postTextLabel.lineBreakMode = .byTruncatingTail
                    
                    return cell
                }
                else {
                    
                    // configure twitter cell and return twitter cell
                    let twt:TWTRTweet = post as! TWTRTweet
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath as IndexPath) as! TWTRTweetTableViewCell
                    
                    cell.tweetView.delegate = self
                    cell.tweetView.showActionButtons = false
                    cell.configure(with: twt)
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    
                    return cell
                }
                
            }
            else {
                // return an empty in case...
                let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath as IndexPath) as! TWTRTweetTableViewCell
                return cell
            }
            
            
        }
        
        
    }
    
    // return the height of the cells using auto layout
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.row == 0 {
            return 140
        }
        else {
            return UITableViewAutomaticDimension
        }
 
        //return UITableViewAutomaticDimension
        
        
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
                
                // - 1 after putting back the banner
                let expandedPost:instagramPost = self.postArray[indexPath.row-1] as! instagramPost
                view.post = expandedPost
                
            }
            
        }
        
    }
    
    @IBAction func unwindToHome(_ sender: UIStoryboardSegue) {
        
        self.didLoad()
        
    }

    @IBAction func tryAgainButtonAction(_ sender: Any) {
        self.checkInternet()
    }
    
}
