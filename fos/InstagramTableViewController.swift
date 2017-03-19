//
//  InstagramTableViewController.swift
//  fos
//
//  Created by Karson Chau on 2017-03-12.
//  Copyright © 2017 Karson Chau. All rights reserved.
//

import UIKit


class InstagramTableViewController: UITableViewController {
    
    var post:instagramPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if post == nil {
            post?.text = "Cannot Load"
            post?.userName = "Cannot Load"
            post?.postImageURL = "Cannot Load"
            post?.profileImageURL = "Cannot load"
        }
        
        //print(post ?? <#default value#>)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "instagramExpanded", for: indexPath) as! InstagramTableViewCell
        
        cell.userNameLabel.text = self.post?.userName
        cell.postTextLabel.text = self.post?.text
        cell.postTextLabel.sizeToFit()
        cell.postTextLabel.numberOfLines = 0
        
        cell.profileImage.sd_setImage(with: URL(string: (self.post?.profileImageURL)!), placeholderImage: #imageLiteral(resourceName: "instagramProfileImage"))
        
        cell.postImage.sd_setImage(with: URL(string: (self.post?.postImageURL)!), placeholderImage: #imageLiteral(resourceName: "cannot load image"))
        
        return cell
    }
    
}
