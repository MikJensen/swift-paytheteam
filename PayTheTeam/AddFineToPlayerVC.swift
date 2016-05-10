//
//  AddFineToPlayerVC.swift
//  Pay the team
//
//  Created by Mik Jensen on 25/04/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class AddFineToPlayerVC: UITableViewController
{
    @IBOutlet var fineTV: UITableView!
    
    var playerObject:NSObject?
    var fineArr = [Fine]()
    var fineObject:Fine!
    let loginObj = KeychainWrapper.objectForKey("IsLoggedIn") as! Login

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //self.fineTV.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")

        loadFines()
        
        self.refreshControl?.addTarget(self, action: #selector(FinesVC.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(sender:AnyObject)
    {
        loadFines()
        self.refreshControl?.endRefreshing()
    }
    
    func loadFines()
    {
        fineArr.removeAll()
        fineTV.reloadData()
        FineModel().GetAllFines()
        {
            returnValue in
            if returnValue.count != 0
            {
                self.fineArr = returnValue
                self.fineArr.sortInPlace({$0.price < $1.price})
                self.fineTV.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return fineArr.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        let title = fineArr[indexPath.row].GetTitle()
        let price = fineArr[indexPath.row].GetPrice()
        
        cell.fineText.text = title
        cell.priceLbl.text = "\(String(price)) Kr."
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let playerObj = playerObject as? Player
        PlayerModel().assignFineToPlayer(fineArr[indexPath.row], playerId: (playerObj?.getId())!)
        NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        
        JLToast.makeText("Bøde er givet til spiller", duration: JLToastDelay.ShortDelay).show()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
