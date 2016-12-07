//
//  ViewController.swift
//  MatchIQ
//
//  Created by arash parnia on 30/11/2016.
//  Copyright © 2016 arash parnia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var card: UIImageView!
    
    @IBOutlet weak var cardLabel: UILabel!
    
    @IBOutlet weak var cardDescription: UITextView!
    
    var imageList:[String] = ["m0.jpg","m1.jpg", "m2.jpg", "m3.jpg"]
    var imagedatabse = [Int: String]()
    let maxImages = 3
    var imageIndex: NSInteger = 0
    
    
    
    override func viewDidLoad() {
//        jsonParser()
        csvParser()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        imagedatabse[1] = imageList[1]
        let p = CGPoint(x: 10, y: 10)
        card.image = textToImage(drawText: "test", inImage: UIImage(named: imageList[imageIndex])!, atPoint: p)
        
        
        
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        //transition contant
        let transition = CATransition()
        transition.type = kCATransitionReveal
        
        
        //change transition based on swipe direction
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                transition.subtype = kCATransitionFromLeft
                
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                transition.subtype = kCATransitionFromBottom
                
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                transition.subtype = kCATransitionFromRight
                
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                transition.subtype = kCATransitionFromTop
                
            default:
                break
            }
        }
        
        
        imageIndex += 1
        if(imageIndex > maxImages) {imageIndex = 0;}
        card.image =  UIImage(named: imageList[imageIndex])
        cardLabel.text = imageList[imageIndex]
        cardDescription.text = imageList[imageIndex]
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        card.layer.add(transition, forKey: kCATransition)
        cardLabel.layer.add(transition, forKey: kCATransition)
        cardDescription.layer.add(transition, forKey: kCATransition)
        CATransaction.commit()
        
        
        
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
    
    
    func csvParser(){
        do {
            let fileManager = FileManager.default
            let path = fileManager.currentDirectoryPath
            print(path)
            let csvData = try String(contentsOfFile: path + "data.csv")
            let csv = csvData.csvRows()
            for row in csv {
                print(row)
            }
        } catch {  
            print(error)  
        }
    }
    
    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    func jsonParser() {
        let urlPath = "http://open.datapunt.amsterdam.nl/Attracties.json"
        guard let endpoint = URL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        let request = URLRequest(url: endpoint)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                print(json)
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }.resume()
    }
    
    
    
    
}


