//
//  MapViewController.swift
//  MatchIQ
//
//  Created by arash parnia on 08/12/2016.
//  Copyright © 2016 arash parnia. All rights reserved.
//


import UIKit
import MapKit
import CoreData
import ImageIO
import AVFoundation


class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate {
     let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var MapView: MKMapView!
    let centerLocation = CLLocationCoordinate2D(
        latitude : 52.3702,
        longitude : 4.8952
    )
    let radious = 0.1
    
    var annotations:[AnnotationView] = []
    
    
    func makeAnnotationsFromCards(){
        
        let fetchRequest = NSFetchRequest<Cards>(entityName: "Cards")
        let resultPredicate = NSPredicate(format: "user_rating == %@", "2")
        
        
        fetchRequest.predicate = resultPredicate
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for card in results {
                let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(card.latitude!)!, longitude: CLLocationDegrees(card.longitude!)!)
                let ann = AnnotationView(coordinate: location, title: card.title!, subtitle: card.address! + " " + card.city! + " " + card.zipcode!)
                annotations.append(ann)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        
    }
    
    override func viewDidLoad() {
        makeAnnotationsFromCards()
        
        MapView.delegate = self
        
        
        let span = MKCoordinateSpanMake(radious, radious)
        let region = MKCoordinateRegion(center: centerLocation, span: span)
        MapView.setRegion(region, animated: true)
        
        
        MapView.mapType = MKMapType.standard
        MapView.isPitchEnabled = false
        MapView.camera.centerCoordinate = centerLocation
      
        
        //add annotations to map
        MapView.addAnnotations(annotations)
        MapView.showAnnotations(annotations, animated: true)

        
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotation = annotation as? AnnotationView
        var view: MKPinAnnotationView
        let identifier = "pin"
        view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: 0, y: 0)
        let btn = UIButton(type: .detailDisclosure)
        view.rightCalloutAccessoryView = btn
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let ann = view.annotation as! AnnotationView
        
        
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Direction", message: "Pick your favorite routing app", preferredStyle: .actionSheet)
        
        // Create the actions
        let applemapAction = UIAlertAction(title: "Apple Map", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("applemap Pressed")
            let placemark = MKPlacemark(coordinate: ann.coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = ann.title
            mapItem.openInMaps()
        }
        let googlemaplAction = UIAlertAction(title: "Google Map", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("googlemap Pressed")
            if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
                UIApplication.shared.openURL(NSURL(string:
                    "comgooglemaps://?saddr=&daddr=\(ann.coordinate.latitude),\(ann.coordinate.longitude)&directionsmode=driving")! as URL)
                
            } else {
                NSLog("Can't use comgooglemaps://");
            }
            
        }
        
        

        // Add the actions
        alertController.addAction(applemapAction)
        alertController.addAction(googlemaplAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
   
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        
    }
    
    //MARK:- MapViewDelegate methods
    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if overlay is MKPolyline {
//            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
//            polylineRenderer.strokeColor = UIColor.blue
//            polylineRenderer.lineWidth = 5
//            return polylineRenderer
//        }
//        return 0
//    }
    
   
    
    
    
    
    
    
    
    func removeAnnotations(){
        MapView.removeAnnotations(annotations)
        annotations.removeAll(keepingCapacity: false)
    }
    
    
}
