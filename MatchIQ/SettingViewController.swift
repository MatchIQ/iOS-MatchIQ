//
//  SettingViewController.swift
//  MatchIQ
//
//  Created by arash parnia on 07/12/2016.
//  Copyright © 2016 arash parnia. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SettingViewController : UIViewController{
     let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBAction func resetapp(_ sender: Any) {
        removeAllFromManagedContext()
        parseJSON()
    }
    
    
    func parseJSON(){
        
        
        let jsonpath = Bundle.main.path(forResource: "data", ofType: "json")
        let jsondata = NSData(contentsOfFile: jsonpath!)
        
        
        let json = JSON(data: jsondata as! Data)
        
        for (_,subJson):(String, JSON) in json {
            let entity =  NSEntityDescription.entity(forEntityName: "Cards", in:managedContext)
            let cards = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            //            print("id : " ,subJson["id"].stringValue)
            cards.setValue(subJson["id"].stringValue, forKey: "id")
            
            //            print("TitleEN : " ,subJson["TitleEN"].stringValue)
            cards.setValue(subJson["TitleEN"].stringValue, forKey: "title")
            
            //            print("ShortdescriptionEN : " ,subJson["ShortdescriptionEN"].stringValue)
            cards.setValue(subJson["ShortdescriptionEN"].stringValue, forKey: "shrt_description")
            
            //            print("Thumbnail : " ,subJson["Thumbnail"].stringValue)
            let thumbnailURL = URL(string: subJson["Thumbnail"].stringValue)
            let imagedata = NSData(contentsOf: thumbnailURL!)
            cards.setValue(imagedata, forKey: "thumbnail")
            
            
            //            print("urls : " ,subJson["urls"].stringValue)
            cards.setValue(subJson["urls"].stringValue, forKey: "urls")
            
            //            print("Adres : " ,subJson["Adres"].stringValue)
            cards.setValue(subJson["Adres"].stringValue, forKey: "address")
            
            
            //            print("City : " ,subJson["City"].stringValue)
            cards.setValue(subJson["City"].stringValue, forKey: "city")
            
            
            //            print("Zipcode : " ,subJson["Zipcode"].stringValue)
            cards.setValue(subJson["Zipcode"].stringValue, forKey: "zipcode")
            
            
            //            print("Latitude : " ,subJson["Latitude"].stringValue)
            cards.setValue(subJson["Latitude"].stringValue, forKey: "latitude")
            
            
            //            print("Longitude : " ,subJson["Longitude"].stringValue)
            cards.setValue(subJson["Longitude"].stringValue, forKey: "longitude")
            
            
            //            print("Tripadvisor ratting : " ,subJson["Tripadvisor ratting"].stringValue)
            cards.setValue(subJson["Tripadvisor ratting"].stringValue, forKey: "trip_advisor_rating")
            
            
            //            print("user rating  : " ,subJson["user rating"].stringValue)
            cards.setValue(subJson["user rating"].stringValue, forKey: "user_rating")
            
            
            
            
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
            //            for(key,value):(String,JSON) in subJson{
            //                print(key," : ",value)
            //            }
        }
        
        
    }
    func removeAllFromManagedContext(){
        let fetchRequest = NSFetchRequest<Cards>(entityName: "Cards")
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult> )
        
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)")
        }
    }

}
