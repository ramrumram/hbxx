//
//  HistoryTableViewController.swift
//  Heartboxx
//
//  Created by dev on 4/22/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//

import UIKit

class HistoryTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    

    @IBOutlet var tableView: UITableView!
    var meals = [History]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
              // Load the sample data.
        loadSampleMeals()
    }
    
    func loadSampleMeals() {
        let photo1 = UIImage(named: "logo")!
      //  let meal1 = History(name: "Caprese Salad", photo: photo1, category: "sdrer dfdf dfdfd dfdf..")!
        
        let photo2 = UIImage(named: "logo")!
      //  let meal2 = History(name: "Chicken and Potatoes", photo: photo2, category: "iiiuu dfdf dfdfd dfdf..")!
        
        let photo3 = UIImage(named: "logo")!
     //   let meal3 = History(name: "Pasta with Meatballs", photo: photo3, category: "oooppp dfdf dfdfd dfdf..")!
        
       // meals += [meal1, meal2, meal3]
        
        
        var history = History()
        history.getRecent()
      //  history.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "HistoryTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HistoryTableViewCell
       
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        cell.lblShopName.text = "meal.name"
       // cell.imgHistory.image = "meal.photo"
        cell.lblCategory.text = "meal.category"
        
        return cell
    }

    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */


  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
