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
import AlamofireImage
import KeychainSwift
class HistoryTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    let keychain = KeychainSwift()
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
              
         let uid = keychain.get("HB_uid")!
        
        Alamofire.request(
            API_Domain + "/api/venues/gethistory/"+uid,
            encoding: URLEncoding.default)
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
                
                if((value["history"]?.count)! > 0) {
                    self.visits = value
                    self.tableView.reloadData()
                }else {
                }
        
        
        }
        
 
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        if((self.visits["history"]) != nil) {
            return (self.visits["history"]?.count)!
        }else {
            return 0
        }
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if((self.visits["history"]) != nil) {
         //   return self.visits["history"]![section].count;
             return 0
        }else {
            return 0
        }
    }
    /*
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
        
    }*/
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "HistoryTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HistoryTableViewCell
       
        let temphistory = visits["history"] as! [NSArray]
        

        //temphistory[0]
        let visit = temphistory[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]  as! [String:AnyObject]
        
        
        
        cell.lblShopName.text = visit["venue_name"] as? String
        let imgurl =  visit["cat_img"]! as? String
     
        let URL = Foundation.URL(string: imgurl!)!
        let placeholderImage = UIImage(named: "logo")!
        
        cell.imgHistory.af_setImage(withURL: URL, placeholderImage: placeholderImage)
        
      
        cell.lblCategory.text = visit["category"] as? String
        
        return cell
    }

    
    
   
 
    
    let blogSegueIdentifier = "ShowNewMessage"
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            if let button = sender as? UIButton {
            let cell = button.superview?.superview as! UITableViewCell
            let destination = segue.destination as? NewMessageController,
            indexPath = self.tableView.indexPath(for: cell)!
                let temphistory = visits["history"] as! [NSArray]
                
                
                //temphistory[0]
                let visit = temphistory[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row] as! [String:AnyObject]
                
          //  print((visit["venue_name"] as? String)!)
            destination!.venueName = (visit["venue_name"] as? String)!
            destination!.address = "---"

          //  print(indexPath.length)
           
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(27);
    }
    
 
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var title = ""
       // if let temp = self.visits["history"]![section][0]["visit_date"]! {
       //      title = temp as! String
       // }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width, height: 18))
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = title
        label.textColor = UIColor.white
        view.addSubview(label)
        view.backgroundColor = UIColor(red: 255/255, green: 198/255, blue: 186/255, alpha: 1)
        
        
      //  let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
      //  view.backgroundColor = UIColor(red: 255/255, green: 101/255, blue: 99/255, alpha: 1)
        return view
        
    }
}
