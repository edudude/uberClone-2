//
//  RiderViewController.swift
//  Uber
//
//  Created by Michael Roloff on 11/15/17.
//  Copyright © 2017 michaelroloff. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class RiderViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet var map: MKMapView!
    
    
    @IBOutlet var callAnUberButton: UIButton!
    
    var locationManager = CLLocationManager ()
    
    var userLocation = CLLocationCoordinate2D ()
    
    var uberHasBeenCalled = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //GETTING LOCATION
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
         if let email = Auth.auth().currentUser?.email {
            
            
            Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                
                self.uberHasBeenCalled = true
                self.callAnUberButton.setTitle("Cancel existing Uber", for: .normal)
                
                //SO the database doesn't get deleted.
                Database.database().reference().child("RideRequests").removeAllObservers()
                
            })
            
        }
        
        
        
        
        
    } //DELEGATE FUNCTION
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord =  manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            
            userLocation = center
            
            //region
            
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            map.setRegion(region, animated: true)
            
            map.removeAnnotations(map.annotations)
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = center
            
            annotation.title = "Your Location"
            
            map.addAnnotation(annotation)
            
            
            
            
            
        }
    }
    
    
    
    
    
    
    @IBAction func callUberTapped(_ sender: Any) {
        //calling uber action
        
        if let email = Auth.auth().currentUser?.email {
            
            if uberHasBeenCalled {
                //UBER CANCELLED
                uberHasBeenCalled = false
                
                callAnUberButton.setTitle("Call an Uber", for: .normal)
                
                Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                    snapshot.ref.removeValue()
                    
                    //SO the database doesn't get deleted.
                    Database.database().reference().child("RideRequests").removeAllObservers()
                    
                })
                
            } else {
                
                let rideRequestDictionary : [String:Any] = ["email" : email, "lat": userLocation.longitude, "lon" : userLocation.longitude ];  Database.database().reference().child("RideRequests").childByAutoId().setValue(rideRequestDictionary)
                self.uberHasBeenCalled = true
                
                self.callAnUberButton.setTitle("Cancel Uber", for: .normal)
                
                
                
            }
            
            
         
            
        }
        
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        //log out
        
        try? Auth.auth().signOut()
        
        navigationController?.dismiss(animated: true, completion: nil)
        
        
        
        
        
        
    }
    
    
    
    // Do any additional setup after loading the view.
}




