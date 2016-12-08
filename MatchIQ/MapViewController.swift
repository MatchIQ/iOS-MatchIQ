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
        let resultPredicate = NSPredicate(format: "user_rating != %@", "0")
        
        
        fetchRequest.predicate = resultPredicate
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for card in results {
                let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(card.latitude!)!, longitude: CLLocationDegrees(card.longitude!)!)
                let ann = AnnotationView(coordinate: location, title: card.title!, subtitle: "Trip Advisor Ratting" + card.trip_advisor_rating!)
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
//            let theimage = UIImage(data:annotation!.imagedata as Data)
//            let hasAlpha = false
//            let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
//            let size = theimage!.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))
//            UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
//            theimage!.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
//            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            view.image = scaledImage
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: 0, y: 0)
            return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        _ = view.annotation as! AnnotationView
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
