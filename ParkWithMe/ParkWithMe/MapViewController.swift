//
//  MapViewController.swift
//  ParkWithMe
//
//  Created by Nhi Quach on 4/21/16.
//  Copyright © 2016 Nhi Quach. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import GeoFire

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var queryButton: UIBarButtonItem!
    let manager = CLLocationManager()
    let rootRef = Firebase(url:"https://blazing-inferno-8100.firebaseio.com")
    let geoFire = GeoFire(firebaseRef: Firebase(url:"https://blazing-inferno-8100.firebaseio.com"))
    var currentLocation : CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        logoutButton.target = self
        logoutButton.action = #selector(MapViewController.logout)
        queryButton.target = self
        queryButton.action = #selector(MapViewController.nearbyPosts)
    }
    
    func logout() {
        rootRef.unauth()
        self.performSegueWithIdentifier("returnToLogin", sender: self)
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Found user's location: \(location)")
            self.currentLocation = location
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            nearbyPosts()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }



    func nearbyPosts() {
        if self.currentLocation == nil {
            return
        }
        let query = self.geoFire.queryAtLocation(self.currentLocation, withRadius: 1.6)

        query.observeEventType(.KeyEntered, withBlock: { (key: String!, location: CLLocation!) in


            let postRef = self.rootRef.childByAppendingPath("posts").childByAppendingPath(key)
            postRef.observeEventType(.Value, withBlock: {
                snapshot in
                let price = snapshot.value["price"] as! String
                self.annotateMap(price, location: location)
            })

        })

    }

    func annotateMap(price: String, location: CLLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        annotation.title = "$" + price
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: true)
    }

}
