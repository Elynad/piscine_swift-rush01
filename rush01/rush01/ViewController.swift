//
//  ViewController.swift
//  rush01
//
//  Created by Mathieu MEYER on 10/25/19.
//  Copyright © 2019 Mathieu MEYER. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentedControlBar: UISegmentedControl!
    @IBAction func locateMeButton(_ sender: UIButton) { self.locateUser() }
    @IBAction func segmentSelected(_ sender: UISegmentedControl) { self.switchMapType() }
    
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initLocationManager()
        initSegmentedControlBar()
        let coords1 = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: 40.586746)!, longitude: CLLocationDegrees(exactly: -108.610891)!)
        let coords2 = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: 42.564874)!, longitude: CLLocationDegrees(exactly: -102.125547)!)
        createRoute(location1: coords1, location2: coords2)
    }

    /// This function inits the location manager so the user can have his position as soon as he clicks on the GPS button.
    func initLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading() // Shows direction
    }
    
    /// Setup the SegmentedControlBar by removing old segments and setting 3 new (about map style)
    func initSegmentedControlBar() {
        segmentedControlBar.removeAllSegments()
        segmentedControlBar.insertSegment(withTitle: "Standard", at: 0, animated: true)
        segmentedControlBar.insertSegment(withTitle: "Satellite", at: 1, animated: true)
        segmentedControlBar.insertSegment(withTitle: "Hybrid", at: 2, animated: true)
        segmentedControlBar.selectedSegmentIndex = 0
    }
    
    /// This "override" from location manager allow us to save the user location each time is is updated.
    /// Then, we can use it as soon as the user asks for it, or to follow the user location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location updated")
        if let current = locations.last {
            self.currentLocation = current
        }
    }
    
    /// Triggered when the user clicks on the GPS button. It will show the user location, and follow
    /// him with his heading.
    func locateUser() {
        mapView?.showsUserLocation = true
        let span = MKCoordinateSpan(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
        if let current = self.currentLocation {
            let location = CLLocationCoordinate2DMake(current.coordinate.latitude, current.coordinate.longitude)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView?.setRegion(region, animated: true)
            /// Following line is used to follow the user (track). When the user drag the map, it automatically
            /// sets back the tracking mode to MKUserTrackingMode.none
            mapView?.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
        }
    }
    
    /// Changes the map type when the user select a segment of the Segmented Control Bar
    func switchMapType() {
        switch segmentedControlBar.selectedSegmentIndex {
        case 0 :
            mapView.mapType = MKMapType.standard
        case 1 :
            mapView.mapType = MKMapType.satellite
        case 2 :
            mapView.mapType = MKMapType.hybrid
        default :
            mapView.mapType = MKMapType.standard
        }
    }
    
    func createRoute(location1 : CLLocationCoordinate2D, location2 : CLLocationCoordinate2D) {
        let source = MKMapItem(placemark: MKPlacemark(coordinate: location1))
        source.name = "Source"
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: location2))
        destination.name = "Destination"
        
//        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }

}

