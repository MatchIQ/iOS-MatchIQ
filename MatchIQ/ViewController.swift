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
    
    var imageList:[String] = ["m0.jpg","m1.jpg", "m2.jpg", "m3.jpg"]
    var imagedatabse = [Int: String]()
    let maxImages = 3
    var imageIndex: NSInteger = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
        card.image = UIImage(named: imageList[imageIndex])
        
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
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        card.layer.add(transition, forKey: kCATransition)
        CATransaction.commit()
        
        
        
    }
    
    
}


