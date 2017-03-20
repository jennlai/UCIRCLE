//
//  MapViewController.swift
//  UCIRCLE
//
//  Created by Jennifer Lai on 3/13/17.
//

import UIKit
import MapKit
import CoreLocation


var coords = [CLLocationCoordinate2D]()

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    
    
    
    
    @IBOutlet weak var map: MKMapView!
    
    
    
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.0001, 0.0001)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        
        //let place:MKCoordinateRegion = MKCoordinateRegionMake(pin, span)
        //map.setRegion(place, animated: true)
        
        //        let pin:CLLocationCoordinate2D = CLLocationCoordinate2DMake(33.641361, -117.854175)
        //
        //        let annotation = MKPointAnnotation()
        //        annotation.coordinate = pin
        //        annotation.title = "Hi"
        //        annotation.subtitle = "Bye"
        //        map.addAnnotation(annotation)
        
        //map.setRegion(region, animated: false)
        
        
        self.map.showsUserLocation = true
        //
        //        distances.removeAll()
        //
        getDistance(myLoc: myLocation)
        //
        //        print(distances)
        
        
        
        
        //        for coord in coords {
        //            let point1 = MKMapPointForCoordinate(myLocation)
        //            let point2 = MKMapPointForCoordinate(coord)
        //            let distance = MKMetersBetweenMapPoints(point1, point2)/1609.34
        //            print(coord)
        //            print(distance)
        ////            let distanceStr = NSString(format: "%.3f", distance)
        //        }
        
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        
        
        for me in events {
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(me.loc, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
                if (placemarks?[0]) != nil {
                    let placemark:CLPlacemark = placemarks![0] as CLPlacemark
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    //                    self.coords.append(coordinates)
                    me.coord = coordinates
                    coords.append(coordinates)
                    
                    
                    let pointAnnotation:MKPointAnnotation = MKPointAnnotation()
                    pointAnnotation.coordinate = coordinates
                    pointAnnotation.title = me.title
                    
                    self.map.addAnnotation(pointAnnotation)
                    self.map.centerCoordinate = coordinates
                    self.map.selectAnnotation(pointAnnotation, animated: true)
                    
                    print("Added annotation to map view")
                }
            } )
            
            
            
        }
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    func getDistance(myLoc: CLLocationCoordinate2D) {
        //        for coord in coords {
        for me in events {
            let point1 = MKMapPointForCoordinate(myLoc)
            let point2 = MKMapPointForCoordinate(me.coord)
            let dist = MKMetersBetweenMapPoints(point1, point2)/1609.34
            me.distance = dist
            //            distances.append(distance)
            //            print(coord)
//            print(me.distance)
            //            let distanceStr = NSString(format: "%.3f", distance)
        }
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    
    
    func centerMapOnLocation(location: CLLocation)
    {
        
        let regionRadius: CLLocationDistance = 1000
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        //        map.setRegion(coordinateRegion, animated: true)
    }
    
    
    
}
