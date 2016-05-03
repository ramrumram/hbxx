//
//  HistoryTableViewController.swift
//  Heartboxx
//
//  Created by dev on 4/22/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class HistoryTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    

    @IBOutlet var tableView: UITableView!
    var visits = [String : AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
              // Load the sample data.
        loadHistory()
    }
    
    func loadHistory() {
        
        
      //  let photo1 = UIImage(named: "logo")!
      //  let meal1 = History(name: "Caprese Salad", photo: photo1, category: "sdrer dfdf dfdfd dfdf..")!
        
     //   let photo2 = UIImage(named: "logo")!
      //  let meal2 = History(name: "Chicken and Potatoes", photo: photo2, category: "iiiuu dfdf dfdfd dfdf..")!
        
    //    let photo3 = UIImage(named: "logo")!
     //   let meal3 = History(name: "Pasta with Meatballs", photo: photo3, category: "oooppp dfdf dfdfd dfdf..")!
        
       // meals += [meal1, meal2, meal3]
        
        
        
        
        
        
        
        
        
        
        Alamofire.request(
            .GET,
            "http://192.168.0.111/heartboxx/venues/gethistory/27",
            parameters: ["include_docs": "true"],
            encoding: .URL)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    //  completion(nil)
                    return
                }
                //  let res = JSON(response.result.value!)
                //   rows["data"] =  res["history"]
                
                guard let value = response.result.value as? [String: AnyObject] else {
                    return
                }
                
                self.visits = value
                self.tableView.reloadData()
               
        
        
                
        
        
        }
        
 
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if((self.visits["history"]) != nil) {
            return (self.visits["history"]?.count)!
        }else {
            return 0
        }
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if((self.visits["history"]) != nil) {
           // return (self.visits["history"]?.count)!
            return self.visits["history"]![section].count;
        }else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
  //       print ("titiele")
        
        if let title = self.visits["history"]![section][0]["visit_date"]! {
            return title as? String
            // there is a value and it's currently undraped and is stored in a constant
        }
        else {
            // no value
            return ""
        }
        
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "HistoryTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HistoryTableViewCell
       
        // Fetches the appropriate meal for the data source layout.
        let visit = self.visits["history"]![indexPath.section][indexPath.row]
        
        UIImage(named: "meal3")!
        
        cell.lblShopName.text = visit["venue_name"] as? String
        cell.imgHistory.image = visit["cat_img"] as? String
        cell.lblCategory.text = visit["category"] as? String
        
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
