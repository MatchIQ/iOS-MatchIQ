//
//  ViewController.swift
//  MatchIQ
//
//  Created by arash parnia on 30/11/2016.
//  Copyright © 2016 arash parnia. All rights reserved.
//
import Foundation
import UIKit
import CoreData

//import SwiftyJSON

class ViewController: UIViewController {
    
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var card: UIImageView!
    
    @IBOutlet weak var cardLabel: UILabel!
    
    @IBOutlet weak var cardDescription: UITextView!
    
    
    @IBOutlet weak var cardRating: UIProgressView!
    
    var cardIndex = -1
    
    

    var results = [Cards]()
    
    
    
    override func viewDidLoad() {
        
//        managedContext.reset()
//        removeAllFromManagedContext()
//        parseJSON()
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
//        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
//        swipeDown.direction = UISwipeGestureRecognizerDirection.down
//        self.view.addGestureRecognizer(swipeDown)
        
        
//        let p = CGPoint(x: 10, y: 10)
//        card.image = textToImage(drawText: "test", inImage: UIImage(named: imageList[imageIndex])!, atPoint: p)
        
       
        
        let fetchRequest = NSFetchRequest<Cards>(entityName: "Cards")
        let resultPredicate = NSPredicate(format: "user_rating == %@", "0")
        
        
        fetchRequest.predicate = resultPredicate
        
        do {
            results = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
       
        var swipeRating = "0"
        
        //transition contant
        let transition = CATransition()
        transition.type = kCATransitionReveal
        
        //change transition based on swipe direction
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                swipeRating = "1"
                transition.subtype = kCATransitionFromLeft
                
//            case UISwipeGestureRecognizerDirection.down:
//                print("Swiped down")
//                transition.subtype = kCATransitionFromBottom
                
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                swipeRating = "0"
                transition.subtype = kCATransitionFromRight
                
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                swipeRating = "2"
                transition.subtype = kCATransitionFromTop
                
            default:
                break
            }
        }
        
        if (cardIndex < results.count && cardIndex > -1){
            results[cardIndex].user_rating = swipeRating
            try! managedContext.save()
        }
        
        
        cardIndex += 1
        
        
        
        if(cardIndex > results.count) {
            //request for more cards
            
            card.image = UIImage(named: "MatchIQ.png")
        }else {
        
        card.image = UIImage(data: results[cardIndex].thumbnail as! Data)
        cardLabel.text = results[cardIndex].title
            if let rating = Float(results[cardIndex].trip_advisor_rating!){
                print(rating)
                cardRating.progress = rating/5
            }
            else {
                cardRating.progress = 0
            }
        cardDescription.text = results[cardIndex].shrt_description
        
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        card.layer.add(transition, forKey: kCATransition)
        cardLabel.layer.add(transition, forKey: kCATransition)
        cardRating.layer.add(transition, forKey: kCATransition)
        cardDescription.layer.add(transition, forKey: kCATransition)
        CATransaction.commit()
        }
        
       
        
    }
    func textToImage(drawText: NSString, inImage: UIImage, atPoint: CGPoint) -> UIImage{
        
        // Setup the font specific variables
        let textColor = UIColor.black
        let textFont = UIFont(name: "Helvetica Bold", size: 48)!
        
        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)
        
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        
        // Put the image into a rectangle as large as the original image
        inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
        
        // Create a point within the space that is as bit as the image
        let rect = CGRect(x:atPoint.x, y:atPoint.y, width:inImage.size.width, height:inImage.size.height)
        
        // Draw the text into an image
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //Pass the image back up to the caller
        return newImage!
        
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

