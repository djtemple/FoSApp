//
//  ExploreTableViewController.swift
//  fos
//
//  Created by Karson Chau on 2017-03-16.
//  Copyright © 2017 Karson Chau. All rights reserved.
//

import UIKit

class ExploreTableViewController: UITableViewController {
    
    let cellTitles = ["Advisor", "Calendar","Workroom Booking","Room Finder", "Research", "FAQ"]
    
    let webLinks = ["https://www.ucalgary.ca/science/undergraduate/usc/advising/contact_program_advisor","http://www.ucalgary.ca/pubs/calendar/current/academic-schedule.html","http://workrooms.ucalgary.ca/rooms.php?s=workrooms", "http://ucmapspro.ucalgary.ca/RoomFinder/", "https://www.ucalgary.ca/science/research", "http://www.ucalgary.ca/science/undergraduate/usc/faq"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return cellTitles.count
    }
    
    // MARK: - Table view cell configure
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreCell", for: indexPath) as! ExploreTableViewCell
        
        cell.titleLabel.text = cellTitles[indexPath.row]
        
        // Configure the cell...
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if(segue.identifier == "ShowResource") {
            
            let view:ResourceViewController = (segue.destination as? ResourceViewController)!
            
            if let selectedCell = sender as? ExploreTableViewCell {
                let indexPath = tableView.indexPath(for: selectedCell)
                
                view.weblink = webLinks[(indexPath?.row)!]
                
                view.title = cellTitles[(indexPath?.row)!]
            }
            
        }
 
         
    }
    
    
}
