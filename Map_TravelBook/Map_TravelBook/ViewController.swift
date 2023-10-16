//
//  ViewController.swift
//  Map_TravelBook
//
//  Created by Fy Spoti on 16/10/2023.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var viewMap: MKMapView!
    
    var locationManager = CLLocationManager()
    
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var commentText: UITextField!
    
    
    var choosenLatitude = Double()
    var choosenLongtitude = Double()
    
    var choosenTitle = ""
    var choosenTitleId = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        viewMap.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 3
        viewMap.addGestureRecognizer(gestureRecognizer)
        
        
        if choosenTitle != "" {
            
        } else {
            
        }
        
        
    }
    
    
    @objc func chooseLocation (gestureRecognizer:UILongPressGestureRecognizer){
        
        if gestureRecognizer.state == .began{
            let touchPoint = gestureRecognizer.location(in: self.viewMap)
            
            let touchPointCoordinate = self.viewMap.convert(touchPoint, toCoordinateFrom: self.viewMap)
            
            choosenLatitude = touchPointCoordinate.latitude
            choosenLongtitude = touchPointCoordinate.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchPointCoordinate
            annotation.title = nameText.text
            annotation.subtitle = commentText.text
            self.viewMap.addAnnotation(annotation)
            
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        viewMap.setRegion(region, animated: true)
    }
    
    
    @IBAction func saveClicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        
        let newPlaces = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
        
        
        newPlaces.setValue(UUID(), forKey: "id")
        newPlaces.setValue(nameText.text!, forKey: "title")
        newPlaces.setValue(commentText.text!, forKey: "subTitle")
        newPlaces.setValue(choosenLatitude, forKey: "latitude")
        newPlaces.setValue(choosenLongtitude, forKey: "longtitude")
        
        do {
            try context.save()
            print("Success")
        } catch {
            print("Errol")
        }
        
    }
    
    

}

