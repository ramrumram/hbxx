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
        
       
        tableView.delegate = self
        tableView.dataSource = self
        
        
        loadMessages()
        tableView.tableFooterView = UIView()
        
        
    }
    
    
    @IBAction func btnRefresh(_ sender: AnyObject) {
        loadMessages()
    }
    
    func loadMessages() {
        
        
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
            let uid = keychain.get("HB_uid")!
        
     //   print(API_Domain+"/api/messages/fetch/"+uid)
            Alamofire.request(
         
                API_Domain+"/api/messages/fetch/"+uid,
                
                encoding: URLEncoding.default)
                .validate()
                .responseJSON { (response) -> Void in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.messages.count;
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MailboxTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MailboxTableViewCell
        
        let message = self.messages[(indexPath as NSIndexPath).row]!
     
        cell.lblTo.text =  message[2] as? String
        cell.lblSub.text =  message[0] as? String
        cell.lblBody.text =  message[1] as? String
        cell.lblDate.text =  message[3] as? String
        
        
        
        return cell
    }
    
    
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  segue.identifier == blogSegueIdentifier{
            let destination = segue.destination as? MailboxDetailViewController,
            indexPath = (self.tableView.indexPathForSelectedRow as NSIndexPath?)?.row
            
            let message = self.messages[indexPath!]
            
            destination?.to =  (message![2] as? String)!
             destination?.subject =  (message![0] as? String)!
             destination?.body =  (message![1] as? String)!
             destination?.date =  (message![3] as? String)!
            
            
            
            //  print((visit["venue_name"] as? String)!)
            //  print(indexPath.length)
            
        }
        
    }
    

}
