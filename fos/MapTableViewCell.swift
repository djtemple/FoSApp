//
//  MapTableViewCell.swift
//  fos
//
//  Created by Karson Chau on 2017-04-08.
//  Copyright © 2017 Karson Chau. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewCell: UITableViewCell, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    var event:Events?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.mapView.delegate = self
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.007, 0.007)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(51.077723, -114.130994)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        self.mapView.setRegion(region, animated: true)
        
    }

    func addAnnotation() {
        
        if event != nil {
            let annotation = MKPointAnnotation()
            let aLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.event!.latitude, self.event!.longitude)
            annotation.coordinate = aLocation
            annotation.title = self.event?.name
            
            self.mapView.addAnnotation(annotation)
        }
        
    }
}
