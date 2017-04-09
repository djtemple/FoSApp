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
    
}

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var eventID:[String] = []
    var eventsArray:[Events] = []
    
    var eventsToday:[Events] = []
    //var eventCoordinates:[CLLocationCoordinate2D] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //activityIndicator.startAnimating()
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.007, 0.007)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(51.077723, -114.130994)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: true)
        
        
        let annotation = MKPointAnnotation()
        let aLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(51.080031, -114.126975)
        annotation.coordinate = aLocation
        annotation.title = "Collaborative Space"
        self.mapView.addAnnotation(annotation)
 
        //tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 80
        
        self.getEventID()
        
        //activityIndicator.stopAnimating()
        //activityIndicator.isHidden = true
        
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
            dateFormatterPrint.dateFormat = "MMM dd E h:mm a"
            
            // start time
            let st = readableJSON?["start"] as! [String:Any]
            let startTime = st["local"] as! String
            
            //print(startTime)
            
            var tempOut = dateFormatter.date(from: startTime)
            let startDate = dateFormatterPrint.string(from: tempOut!)
            let startArray = startDate.components(separatedBy: " ")
            //print(startArray)
            
            // end time
            let end = readableJSON?["end"] as! [String:Any]
            let endTime = end["local"] as! String
            
            tempOut = dateFormatter.date(from: endTime)
            let endDate = dateFormatterPrint.string(from: tempOut!)
            let endArray = endDate.components(separatedBy: " ")
            
            //print(endArray)
            
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

            let evt:Events = Events(name: name, eventImageURL: imageURL, description: description, startTime: startArray, endTime: endArray, address: address, longitude: longitude!, latitude: latitude!, venueName: venueName, city: city, organizerName:organizerName, url: url)
            
            //print(evt)
            self.eventsArray.append(evt)
            
        }
        catch {
            print(error)
        }

        self.tableView.reloadData()
        
        self.getEventsToday()
    }
    
    
    // get the coordinates and add them to array
    func getEventsToday() {
        // filter events to events today.
        // add them to the annotation array
        
        
        for i in 0..<self.eventsArray.count {
            let evt = self.eventsArray[i]
            let dateArray = evt.startTime
            
            let month = dateArray[0]
            let day = dateArray[1]
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd"
            
            let today = formatter.string(from: date)
            
            let evtDate = month + " " + day
            if(evtDate == today) {
                //print("same date")
                self.eventsToday.append(evt)
            }
            
        }
        
        self.addEventAnnotations()
        
    }
    
    // Add annotations to the map
    func addEventAnnotations(){
        for i in 0..<self.eventsToday.count {
            
            let evt = self.eventsToday[i]
            
            let annotation = MKPointAnnotation()
            let aLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(evt.latitude, evt.longitude)
            annotation.coordinate = aLocation
            annotation.title = evt.name
            self.mapView.addAnnotation(annotation)
        }
        
        //self.activityIndicator.stopAnimating()
        //self.activityIndicator.isHidden = true
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
        //return 1
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
        
        // this one includes the label for city 
        //let detail = startTime[2] + " " + startTime[3] + startTime[4] + " - " + evt.venueName + " - " + evt.city
       
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
        /*
        else if(segue.identifier == "ShowEventWeb") {
            let eventView:EventDetailViewController = (segue.destination as? EventDetailViewController)!
            
            if let selectEvent = sender as? EventTableViewCell {
                let index = self.tableView.indexPath(for: selectEvent)!
                
                let evt2  = self.eventsArray[index.row]
                
                eventView.weblink = evt2.url
            }
            
        }
        */
        
    }


}
