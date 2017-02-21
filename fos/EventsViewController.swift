//
//  EventsViewController.swift
//  fos
//
//  Created by Karson Chau on 2017-02-09.
//  Copyright © 2017 Karson Chau. All rights reserved.
//

import UIKit
import MapKit

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        

        // Do any additional setup after loading the view.
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
        return 1
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        // Configure the cell...
        cell.monthLabel.text? = "Feb"
        cell.dateLabel.text? = "24"
        cell.titleLabel.text? = "Science Fair"
        cell.detailLabel.text? = "Fri 12:00pm - Gym - Calgary"
        
        
        return cell
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
