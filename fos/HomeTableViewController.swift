//
//  HomeTableViewController.swift
//  fos
//
//  Created by Karson Chau on 2017-02-09.
//  Copyright © 2017 Karson Chau. All rights reserved.
//

import UIKit
import TwitterKit

class HomeTableViewController: TWTRTimelineViewController {

    
    var imageArray = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = TWTRAPIClient()
        self.dataSource = TWTRUserTimelineDataSource(screenName: "UofC_Science", apiClient: client)
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let scrollCell = tableView.dequeueReusableCell(withIdentifier: "ScrollCell", for: indexPath) as! ScrollTableViewCell
            
           let  imageArray = [#imageLiteral(resourceName: "slide 1"), #imageLiteral(resourceName: "darwin_lecture_shoutout2017_2")]
            
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
                iView.frame = CGRect(x: xPosition, y: 0, width: scrollCell.scollView.frame.width, height: scrollCell.scollView.frame.height)
                
                scrollCell.scollView.contentSize.width = scrollCell.scollView.frame.width * CGFloat(i + 1)
                scrollCell.scollView.addSubview(iView)
                
            }

            return scrollCell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TWTRTweetTableViewCell
            cell.configure(with: self.dataSource as! TWTRTweet)
            return cell
        }
        

    }
    
     */
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
