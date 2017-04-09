//
//  EventDetailsTableViewController.swift
//  fos
//
//  Created by Karson Chau on 2017-03-21.
//  Copyright © 2017 Karson Chau. All rights reserved.
//

import UIKit

class EventDetailsTableViewController: UITableViewController {
    
    var event:Events?

    override func viewDidLoad() {
        
        //print(event)

        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()

        tableView.alwaysBounceVertical = false
        
        tableView.estimatedRowHeight = 50
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
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let imageCell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath as IndexPath) as! ImageTableViewCell
            
            imageCell.eventImage.sd_setImage(with: URL(string: (self.event?.eventImageURL)!), placeholderImage: #imageLiteral(resourceName: "cannot load image"), options: [])
            
            return imageCell
        }
        else if (indexPath.row == 1) {
            let nameCell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath as IndexPath) as! NameTableViewCell
            let startTime = self.event?.startTime
            
            nameCell.monthLabel.text? = (startTime?[0])!
            nameCell.dateLabel.text? = (startTime?[1])!
            
            nameCell.nameLabel.text? = (self.event?.name)!
            
            nameCell.venueLabel.text? = "by " + (self.event?.organizerName)!
            
            return nameCell
            
        }
        else if (indexPath.row == 2) {
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath as IndexPath) as! ButtonTableViewCell
            
            buttonCell.url = self.event?.url
            buttonCell.delegate = self
            buttonCell.selectedEvent = self.event
            
            return buttonCell
        }
        else if (indexPath.row == 3) {
            let locationCell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath as IndexPath) as! LocationTableViewCell
            
            let startTime = self.event?.startTime
            let endTime = self.event?.endTime
            
            
            let startDate = (startTime?[0])!+(startTime?[1])!+(startTime?[2])!+(startTime?[3])!+(startTime?[4])!
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMddEh:mma"
            let unFormat = formatter.date(from: startDate)
            
            let printFormat = DateFormatter()
            //Friday, February 24 at 12 PM -
            printFormat.dateFormat = "EEEE, MMMM dd 'at' h:mma '-'"
            let dateFormat = printFormat.string(from: unFormat!)
            
            
            locationCell.dateLabel.text = dateFormat + " " + (endTime?[3])! + (endTime?[4])!

            locationCell.dateLabel.adjustsFontSizeToFitWidth = true
            locationCell.dateLabel.minimumScaleFactor = 0.2
            
            locationCell.addressLabel.text = self.event?.address
            locationCell.addressLabel.adjustsFontSizeToFitWidth = true
            locationCell.addressLabel.minimumScaleFactor = 0.2
            
            return locationCell
        }
        else {
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath as IndexPath) as! DetailTableViewCell
            
            detailCell.descriptionLabel.numberOfLines = 0
            detailCell.descriptionLabel.text = self.event?.description
            
            return detailCell
        }
    }
    

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
