//
//  EventsViewController.swift
//  fos
//
//  Created by Karson Chau on 2017-02-09.
//  Copyright © 2017 Karson Chau. All rights reserved.
//

import UIKit
import MapKit
import Alamofire


struct Events {
    var name:String
    var eventImageURL:String
    var description:String
    var startTime:[String]
    var endTime:[String]
    var address:String
    var longitude:Double
    var latitude:Double
    
    var venueName:String
    var city:String
    var organizerName:String
    
    var url:String
    
    var startDate:Date
    var endDate:Date
    
}

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var internetConnectionLabel: UILabel!
    
    @IBOutlet weak var tryAgainButton: UIButton!
    
    var eventID:[String] = []
    var eventsArray:[Events] = []
    
    var refreshControl = UIRefreshControl()
    var reachability = Reachability()
    //let searchBar = UISearchBar()
    
    var isVisible:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.activityIndicator.startAnimating()
        //self.activityIndicator.isHidden = false
        
        self.imageView.image = UIImage(named: "city_11")
        
        self.refreshControl.addTarget(self, action: #selector(EventsViewController.refresh(sender:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl)

        //self.getEventID()
        
        self.checkInternet()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // check internet connection
        
        // but do you have to reload the data if the data is already there?
    }
    
    func checkInternet() {
        if reachability?.currentReachabilityStatus == .notReachable {
            self.activityIndicator.isHidden = true
            self.internetConnectionLabel.isHidden = false
            self.tryAgainButton.isHidden = false
            
            //self.tableView.tableFooterView = UIView()
            
            self.tableView.separatorStyle = .none
            
        }
        else {
            self.internetConnectionLabel.isHidden = true
            self.tryAgainButton.isHidden = true
            
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
            
            self.tableView.separatorStyle = .singleLine

            
            self.getEventID()
        }
    }
    
    @IBAction func tryAgainButtonAction(_ sender: Any) {
        self.checkInternet()
    }
   
    @IBAction func searchBarItem(_ sender: Any) {
        
       
    }
    
    func refresh(sender: AnyObject) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.eventID = []
            self.eventsArray = []
            self.getEventID()
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // get the event ids from the user
    func getEventID() {
        let url = "https://www.eventbriteapi.com/v3/users/me/owned_events/?status=live&token=EZ73BAWEGUIBY3JQWIT7"
        
        Alamofire.request(url).responseJSON { (response) in
            self.parseEventID(JSONData: response.data!)
        }
    }
    
    func parseEventID(JSONData: Data) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .allowFragments) as? NSDictionary
            let datas = readableJSON?["events"] as? [[String:Any]]
            
            for data in datas! {
                //print(data)
                
                let id = (data["id"] as? String)!
                //print(id)
                
                eventID.append(id)
            }
            //print(eventID)
            
        }
        catch {
            print(error)
        }
        
        self.getEvents()

    }
    
    
    // get the content of the events
    func getEvents() {
        for i in 0..<self.eventID.count {
            let id = self.eventID[i]
            let url = "https://www.eventbriteapi.com/v3/events/" + id + "/?location.address=Indore&expand=organizer,venue&token=EZ73BAWEGUIBY3JQWIT7"
            Alamofire.request(url).responseJSON { (response) in
                self.parseEvent(JSONData: response.data!)
            }
        }
    }
    
    func parseEvent(JSONData: Data) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .allowFragments) as? NSDictionary
            
            
            //url
            let url = readableJSON?["url"] as! String
            
            //name
            let nameText = readableJSON?["name"] as! [String: Any]
            let name = (nameText["text"] as! String)
            
            // description
            let descrp = readableJSON?["description"] as! [String:Any]
            let description = descrp["text"] as! String
            
            // Configure date formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM d E h:mm a"
            
            // start time
            let st = readableJSON?["start"] as! [String:Any]
            let startTime = st["local"] as! String
            
            //print(startTime)
            
            let startDate = dateFormatter.date(from: startTime)
            var tempOut = dateFormatterPrint.string(from: startDate!)
            let startArray = tempOut.components(separatedBy: " ")
            //print(startArray)
            
            // end time
            let end = readableJSON?["end"] as! [String:Any]
            let endTime = end["local"] as! String
            
            let endDate = dateFormatter.date(from: endTime)
            tempOut = dateFormatterPrint.string(from: endDate!)
            let endArray = tempOut.components(separatedBy: " ")
            
            
            // venue then address
            let venue = readableJSON?["venue"] as! [String:Any]
            let venueName = venue["name"] as! String
            
            let add = venue["address"] as! [String:Any]
            // address of the event
            
            let city = add["city"] as! String
            
            let displayAddress = add["localized_address_display"] as! String
            let areaDisplay = add["localized_area_display"] as! String
            let address = displayAddress + " " + areaDisplay
            
            // coordinates
            let lat = add["latitude"] as! String
            let latitude = Double(lat)
            let long = add["longitude"] as! String
            let longitude = Double(long)
            
            // get the picture of the event
            let logo = readableJSON?["logo"] as! [String:Any]
            let original = logo["original"] as! [String:Any]
            let imageURL = original["url"] as! String
            
            
            // Get organizers name
            let organizer = readableJSON?["organizer"] as! [String:Any]
            let organizerName = organizer["name"] as! String

            let evt:Events = Events(name: name, eventImageURL: imageURL, description: description, startTime: startArray, endTime: endArray, address: address, longitude: longitude!, latitude: latitude!, venueName: venueName, city: city, organizerName:organizerName, url: url, startDate:startDate!, endDate: endDate!)
            
            //print(evt)
            self.eventsArray.append(evt)
            
        }
        catch {
            print(error)
        }

        self.tableView.reloadData()
        
        if self.activityIndicator.isAnimating {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
       
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
        self.scrollToFirstRow()
        
    }
    
    func scrollToFirstRow() {
        
        if !eventsArray.isEmpty {
            let indexPath = NSIndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
        }
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: false)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return eventsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        // Configure the cell...
        
        let evt = eventsArray[indexPath.row]
    
        let startTime = evt.startTime
        
        _ = startTime.index(startTime.startIndex, offsetBy: 3)
        
        cell.monthLabel.text? = startTime[0]
        cell.dateLabel.text? = startTime[1]
        
        cell.titleLabel.text? = evt.name
       
        let detail = startTime[2] + " " + startTime[3] + startTime[4] + " - " + evt.venueName

        cell.detailLabel.text? = detail
        cell.detailLabel.adjustsFontSizeToFitWidth = true
        cell.detailLabel.minimumScaleFactor = 0.2
        
        return cell
     }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "ShowEventDetails") {
            let view:EventDetailsTableViewController = (segue.destination as? EventDetailsTableViewController)!
            
            if let selectedPost = sender as? EventTableViewCell {
                let indexPath = self.tableView.indexPath(for: selectedPost)!
                
                let evt = self.eventsArray[indexPath.row]
                view.event = evt
            }
            
        }
        
    }


}
