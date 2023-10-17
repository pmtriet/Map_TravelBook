//
//  ViewController.swift
//  MapArtBook1610
//
//  Created by Minh Triet Pham on 16/10/2023.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var managedObjectContext : NSManagedObjectContext!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var saveButtonClicked: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    var locationManager = CLLocationManager()
    
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    var chosenTitle = ""
    var chosenSubTitle = ""
    
//    var annotationTitle = ""
//    var annotationSubTitle = ""
//    var annotationLatitude = Double()
//    var annotationLongitude = Double()
    
    var selectedObject: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer: )))
        gestureRecognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(gestureRecognizer)
        
        
        
        let hideTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideTapRecognizer)
        
        
        if selectedObject != nil {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let context = appDelegate.persistentContainer.viewContext
//            
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
//            let idString = selectedTitleId!.uuidString
//            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
//            fetchRequest.returnsObjectsAsFaults = false
//            
////            saveButtonClicked.isHidden = true
//            
//            do {
//                let results = try context.fetch(fetchRequest)
//                if results.count > 0 {
//                    
//                    for result in results as! [NSManagedObject] {
//                        if let title = result.value(forKey: "title") as? String {
//                            annotationTitle = title
//                            
//                            
//                            if let subtitle = result.value(forKey: "subtitle") as? String {
//                                annotationSubTitle = subtitle
//                                
//                                if let latitude = result.value(forKey: "latitude") as? Double {
//                                    annotationLatitude = latitude
//                                    
//                                    if let longitude = result.value(forKey: "longitude") as? Double {
//                                        annotationLongitude = longitude
//                                        
//                                        let annotation = MKPointAnnotation()
//                                        annotation.title = annotationTitle
//                                        annotation.subtitle = annotationSubTitle
//                                        let coordinate = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotationLongitude)
//                                        annotation.coordinate = coordinate
//                                        
//                                        mapView.addAnnotation(annotation)
//                                        
//                                        nameTextField.text = annotationTitle
//                                        commentTextField.text = annotationSubTitle
//                                        
//                                        
//                                        
//                                        
//                                        //zoom pin location when select place from table view
//                                        locationManager.stopUpdatingLocation()
//                                        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//                                        let region = MKCoordinateRegion(center: coordinate, span: span)
//                                        mapView.setRegion(region, animated: true)
//                                    }
//                                }
//                                
//                                
//                            }
//                        }
//                        
//                        
//                        
//                    }
//                }
//            } catch {
//                print("error")
//            }
            chosenTitle = selectedObject?.value(forKey: "title") as! String
            chosenSubTitle = selectedObject?.value(forKey: "subtitle") as! String
            chosenLatitude = selectedObject?.value(forKey: "latitude") as! Double
            chosenLongitude = selectedObject?.value(forKey: "longitude") as! Double
            
            
            
            let annotation = MKPointAnnotation()
            annotation.title = chosenTitle
            annotation.subtitle = chosenSubTitle
            let coordinate = CLLocationCoordinate2D(latitude: chosenLatitude, longitude: chosenLongitude)
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            
            
            nameTextField.text = chosenTitle
            commentTextField.text = chosenSubTitle
            
            
            //zoom pin location when select place from table view
            locationManager.stopUpdatingLocation()
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
        } else {
//            updateButton.isHidden = true
        }
    }
    
    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            let touchedCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            
            chosenLatitude = touchedCoordinates.latitude
            chosenLongitude = touchedCoordinates.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinates
            annotation.title = nameTextField.text
            annotation.subtitle = commentTextField.text
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if selectedObject == nil {
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        } else {
            
        }
    }
    
    //view detail pin  when user tap pin annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "myAnnotation"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = UIColor.black
            
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }

    //navigate to
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if selectedObject != nil {
            let requestLocation = CLLocation(latitude: chosenLatitude, longitude: chosenLongitude)
            
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                //closure
                
                
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        
                        let newPlaceMark = MKPlacemark(placemark: placemark[0])
                        let item = MKMapItem(placemark: newPlaceMark)
                        item.name = self.chosenTitle
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        item.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
        let context = appDelegate.persistentContainer.viewContext
        if selectedObject != nil {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let context = appDelegate.persistentContainer.viewContext
////            let managedObjectContext : NSManagedObjectContext?
//            
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
//            let idString = selectedTitleId!.uuidString
//            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
//            fetchRequest.returnsObjectsAsFaults = false
            
            //            saveButtonClicked.isHidden = true
            
            selectedObject?.setValue(nameTextField.text, forKey: "title")
            selectedObject?.setValue(commentTextField.text, forKey: "subtitle")
            selectedObject?.setValue(chosenLatitude, forKey: "latitude")
            selectedObject?.setValue(chosenLongitude, forKey: "longitude")
            
            do {
//                let results = try context.fetch(fetchRequest)
//                if results.count > 0 {
//                    
//                for result in results as! [NSManagedObject] {
//                    result.setValue(nameTextField.text, forKey: "title")
//                    result.setValue(commentTextField.text, forKey: "subtitle")
//                        
//                }
                    
                try context.save()
                } catch {
                print("error")
            }
        } else {
            
            let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
            
            newPlace.setValue(UUID(), forKey: "id")
            newPlace.setValue(nameTextField.text, forKey: "title")
            newPlace.setValue(commentTextField.text, forKey: "subtitle")
            newPlace.setValue(chosenLatitude, forKey: "latitude")
            newPlace.setValue(chosenLongitude, forKey: "longitude")
            newPlace.setValue(UUID(), forKey: "id")
            
            do {
                try context.save()
                print("okay")
            } catch {
                print("error")
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newPlace"), object: nil)
        navigationController?.popViewController(animated: true)
    }
    

}

