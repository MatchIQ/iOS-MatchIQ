//
//  AnnotationView.swift
//  MatchIQ
//
//  Created by arash parnia on 08/12/2016.
//  Copyright © 2016 arash parnia. All rights reserved.
//


import MapKit
import UIKit


class AnnotationView : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, image: UIImage) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}


//class AnnotationView: NSObject, MKAnnotation {
//    let title :String?
//    let coordinate: CLLocationCoordinate2D
//    
//    let card = Cards()
//    
//    init(card : Cards) {
//        self.title = card.title!
//        self.coordinate = CLLocationCoordinate2D(latitude: Double(card.latitude!)!, longitude: Double(card.longitude!)!)
//        self.imagedata = card.thumbnail!
//        super.init()
//    }
//    
//}
