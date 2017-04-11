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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()

        tableView.alwaysBounceVertical = false
        
        tableView.estimatedRowHeight = 60
        
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
        return 6
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
            printFormat.dateFormat = "EEEE, MMMM d 'at' h:mma '-'"
            let dateFormat = printFormat.string(from: unFormat!)
            
            
            locationCell.dateLabel.text = dateFormat + " " + (endTime?[3])! + (endTime?[4])!

            locationCell.dateLabel.adjustsFontSizeToFitWidth = true
            locationCell.dateLabel.minimumScaleFactor = 0.2
            
            locationCell.addressLabel.text = self.event?.address
            
            return locationCell
        }
        else if (indexPath.row == 4) {
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath as IndexPath) as! DetailTableViewCell
            
            detailCell.descriptionLabel.numberOfLines = 0
            detailCell.descriptionLabel.text = self.event?.description
            
            return detailCell
        }
        else {
            let mapCell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath as IndexPath) as! MapTableViewCell
            
            mapCell.event = self.event
            mapCell.addAnnotation()
            
            return mapCell
        }
    }
    

}
