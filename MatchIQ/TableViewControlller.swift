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

class TableViewController : UITableViewController ,NSFetchedResultsControllerDelegate{
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet var TheTableView: UITableView!
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<Cards> = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<Cards>(entityName: "Cards")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //Filter anything with userratting of 0
        let resultPredicate = NSPredicate(format: "user_rating == %@", "2")
        fetchRequest.predicate = resultPredicate
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    override func viewDidLoad() {
        
        
//        removeAllFromManagedContext()
        
//        insertIntoManagedContext()
        
        
    
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
        super.viewDidLoad()
        
    }
    //MARK: -
    // MARK: Fetched Results Controller Delegate Methods
    
    private func controllerWillChangeContent(controller: NSFetchedResultsController<Cards>) {
        TheTableView.beginUpdates()
    }
    
    private func controllerDidChangeContent(controller: NSFetchedResultsController<Cards>) {
        TheTableView.endUpdates()
    }
    
    
    //MARK: Table view Delegate Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = fetchedResultsController.object(at: indexPath)
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TheCell")! as UITableViewCell
        
        cell.textLabel?.text = record.title
        cell.imageView?.image = UIImage(data: record.thumbnail as! Data)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }

}

