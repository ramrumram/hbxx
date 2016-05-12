import UIKit
import Alamofire
import SwiftyJSON
import KeychainSwift
class MailboxViewController: UIViewController,UITableViewDataSource, UITableViewDelegate   {

    @IBOutlet var tableView: UITableView!
    //var visits = [String : AnyObject]()
    var messages = Dictionary<Int, NSMutableArray>()
    let blogSegueIdentifier = "MessageDetailSegue"
    let keychain = KeychainSwift()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        loadMessages()
        tableView.tableFooterView = UIView()
        
        
    }
    
    
    
    func loadMessages() {
        
        
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        
            let uid = keychain.get("HB_uid")!
            
            Alamofire.request(
                .GET,
                API_Domain+"/api/messages/fetch/"+uid,
                
                encoding: .URL)
                .validate()
                .responseJSON { (response) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    guard response.result.isSuccess else {
                        print("Error while fetching remote rooms: \(response.result.error)")
                        //  completion(nil)
                        return
                    }
                    let res = JSON(response.result.value!)
                    if let inbox = res["data"].array {
                        
                        var i = 0
                        while i < inbox.count {
                            var tsub = ""
                            var tto = ""
                            var tmsg = ""
                            var tdate = ""
                            var tid = ""
                            
                            
                            if let sub = inbox[i]["subject"].string {
                                tsub = sub
                            }
                            if let msg = inbox[i]["message"].string {
                                tmsg = msg
                            }
                            if let to = inbox[i]["to"].string {
                                tto = to
                            }
                            if let date = inbox[i]["date"].string {
                                tdate = date
                            }
                            if let id = inbox[i]["id"].string {
                                tid = id
                            }
                            
                            self.messages [i] = [tsub, tmsg, tto, tdate, tid]
                            
                            i = i+1

                        }
                    self.tableView.reloadData()
                    
                
                    }else{
                        print("empty inbox")
                    }
            
            
        
        
        
    }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.messages.count;
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MailboxTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MailboxTableViewCell
        
        let message = self.messages[indexPath.row]!
     
        cell.lblTo.text =  message[2] as? String
        cell.lblSub.text =  message[0] as? String
        cell.lblBody.text =  message[1] as? String
        cell.lblDate.text =  message[3] as? String
        
        
        
        return cell
    }
    
    
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if  segue.identifier == blogSegueIdentifier{
            let destination = segue.destinationViewController as? PlaceDetailViewController,
            indexPath = self.tableView.indexPathForSelectedRow?.row
            let temphistory = self.messages
            
            
            //temphistory[0]
            let visit = temphistory[indexPath!]
            
            //  print((visit["venue_name"] as? String)!)
            destination!.venueName = visit!
            //  print(indexPath.length)
            
        }
        
    }
    

}
