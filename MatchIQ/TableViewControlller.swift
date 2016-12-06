//
//  TableViewControlller.swift
//  MatchIQ
//
//  Created by arash parnia on 06/12/2016.
//  Copyright © 2016 arash parnia. All rights reserved.
//

import Foundation
import UIKit
class TableViewController : UITableViewController{
    
    
    @IBOutlet var TheTableView: UITableView!
    
    override func viewDidLoad() {
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
