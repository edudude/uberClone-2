//
//  AcceptRequestViewController.swift
//  Uber
//
//  Created by Michael Roloff on 11/16/17.
//  Copyright © 2017 michaelroloff. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class AcceptRequestViewController: UIViewController {
    @IBOutlet var map: MKMapView!
    
    var requestLocation = CLLocationCoordinate2D()
    var driverLocation = CLLocationCoordinate2D()
    var requestEmail = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create map
        
        let region = MKCoordinateRegion(center: requestLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        map.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = requestLocation
        annotation.title = requestEmail
        map.addAnnotation(annotation)
        
        
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
        //update the ride request
        Database.database().reference().child("rideRequests").queryOrdered(byChild: "email").queryEqual(toValue: requestEmail).observe(.childAdded) { (snapshot) in
            snapshot.ref.updateChildValues(["driverLat":self.driverLocation.latitude, "driverLon": self.driverLocation.longitude])
            
            Database.database().reference().child("RideRequests").removeAllObservers()
            
        }
        
        
        
        
        
        //give directions
        
        let requestCLLocation = CLLocation(latitude: requestLocation.latitude, longitude: requestLocation.longitude)
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
            if let placemarks = placemarks {
            
            if placemarks.count > 0 {
                let placeMark = MKPlacemark(placemark: placemarks[0])
                let mapItem = MKMapItem(placemark: placeMark)
                mapItem.name = self.requestEmail
                let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                mapItem.openInMaps(launchOptions: options )
            }
            
        }
        
        
        
        
        
    }
    

}
}
