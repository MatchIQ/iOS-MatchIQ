//
//  TableViewControlller.swift
//  MatchIQ
//
//  Created by arash parnia on 06/12/2016.
//  Copyright © 2016 arash parnia. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TableViewController : UITableViewController{
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet var TheTableView: UITableView!
    
    func removeAllFromManagedContext(){
        let fetchRequest = NSFetchRequest<Cards>(entityName: "Cards")
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult> )
        
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)")
        }
    }
    
    
    func insertIntoManagedContext(){
        
        let entity =  NSEntityDescription.entity(forEntityName: "Cards", in:managedContext)
        
        let cards = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        
        let date = NSDate()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        let seconds = calendar.component(.second, from: date as Date)
        let nanosec = calendar.component(.nanosecond, from: date as Date)
        cards.setValue(nanosec, forKey: "id")
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    
    override func viewDidLoad() {
        
        
        
        
        
      
        
//        removeAllFromManagedContext()
        
        insertIntoManagedContext()
        
        
        
        
        
        
        let fetchRequest = NSFetchRequest<Cards>(entityName: "Cards")
        
       
        do {
            let results = try managedContext.fetch(fetchRequest)
            for  c in results {
                print(c.id)
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
       
        super.viewDidLoad()
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TheCell")! as UITableViewCell
        
        cell.textLabel?.text = "TEST"
        cell.imageView?.image = UIImage(named: "m0.jpg")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

}
