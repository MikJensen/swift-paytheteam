//
//  FinesVC.swift
//  Pay the team
//
//  Created by Mik Jensen on 23/03/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class FinesVC: UITableViewController
{
    var fineArr = [Fine]()
    var fineObject:Fine!
    var loginStatus = 0
    let loginObj = KeychainWrapper.objectForKey("IsLoggedIn") as! Login
    
    var deleteFineIndexPath: NSIndexPath? = nil
    
    var leftBarButtonItem : UIBarButtonItem!
    
    @IBOutlet var fineTV: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.leftBarButtonItem = UIBarButtonItem(title: "Tilføj", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FinesVC.goToAddFineAction(_:)))
        
        // Admin status is 1
        if loginObj.getStatus() == 1
        {
            fineTV.editing = false
            self.navigationItem.leftBarButtonItem = self.leftBarButtonItem
        }
        
        loadFines()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FinesVC.reloadFines(_:)),name:"reload", object: nil)
        
        self.refreshControl?.addTarget(self, action: #selector(FinesVC.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func refresh(sender:AnyObject)
    {
        loadFines()
        self.refreshControl?.endRefreshing()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source

    func goToAddFineAction(sender: UIBarButtonItem)
    {
        //print("Action")
        performSegueWithIdentifier("segueAddFine", sender: self)
    }
    func loadFines()
    {
        fineArr.removeAll()
        FineModel().GetAllFines(){
            returnValue in
            if returnValue.count != 0
            {
                self.fineArr = returnValue
                self.fineArr.sortInPlace({$0.price < $1.price})
                self.fineTV.reloadData()
            }
        }
    }
    func reloadFines(notification: NSNotification)
    {
        loadFines()
    }
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
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let delete = UITableViewRowAction(style: .Destructive, title: "Slet")
        {
            action, indexPath in
            self.deleteFineIndexPath = indexPath
            let fine = self.fineArr[indexPath.row].GetTitle()
            self.confirmDelete(fine)
        }
        
        return [delete]
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        if loginObj.getStatus() == 1
        {
            return true
        }
        else
        {
            return false
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell

        // Admin status is 1
        if loginObj.getStatus() == 1
        {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        let title = fineArr[indexPath.row].GetTitle()
        let price = fineArr[indexPath.row].GetPrice()
        
        cell.fineText.text = title
        cell.priceLbl.text = "\(String(price)) Kr."

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        // Admin status is 1
        if loginObj.getStatus() == 1
        {
            fineObject = fineArr[indexPath.row]
            performSegueWithIdentifier("segueEditFine", sender: self)
        }
    }
    
    // MARK: - Alert
    
    func confirmDelete(fine: String)
    {
        let alert = UIAlertController(title: "Slet bøde", message: "Er du sikker på at du vil slette bøden \"\(fine)\" permanent?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Slet", style: .Destructive, handler: handleDeleteFine)
        let CancelAction = UIAlertAction(title: "Annuller", style: .Cancel, handler: cancelDeleteFine)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func handleDeleteFine(alertAction: UIAlertAction!) -> Void
    {
        if let indexPath = deleteFineIndexPath
        {
            fineTV.beginUpdates()
            
            FineModel().DeleteFine(self.fineArr[indexPath.row].GetTitle())
            {
                NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
            }
            
            fineTV.endUpdates()
        }
    }
    
    func cancelDeleteFine(alertAction: UIAlertAction!)
    {
        deleteFineIndexPath = nil
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let editFineVC = segue.destinationViewController as? EditFineVC
        if segue.identifier == "segueEditFine"
        {
            editFineVC?.fineObject = fineObject
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
    {
        return false
    }

}
