//
//  PlayerVC.swift
//  Pay the team
//
//  Created by Mik Jensen on 04/04/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit
import CloudKit

class PlayerVC: UITableViewController
{

    var playerArr = [Player]()
    var playerObject:Player!
    
    let loginObj = KeychainWrapper.objectForKey("IsLoggedIn") as! Login
    
    var deletePlayerIndexPath: NSIndexPath? = nil

    var leftBarButtonItem : UIBarButtonItem!
    
    @IBOutlet var PlayerTV: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("hold: \(loginObj.getTeam())")
        
        // Left bar button
        self.leftBarButtonItem = UIBarButtonItem(title: "Tilføj", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FinesVC.goToAddFineAction(_:)))
        
        // Admin status is 1
        if loginObj.getStatus() == 1
        {
            // Turn on bar buttons
            //PlayerTV.editing = false
            self.navigationItem.leftBarButtonItem = self.leftBarButtonItem
        }
        
        loadPlayers()
        // Reload tabelview from another class
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlayerVC.reloadPlayers(_:)),name:"reload", object: nil)
        
        // Refresh with swipe
        self.refreshControl?.addTarget(self, action: #selector(PlayerVC.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func refresh(sender:AnyObject)
    {
        loadPlayers()
        self.refreshControl?.endRefreshing()
    }
    func goToAddFineAction(sender: UIBarButtonItem)
    {
        performSegueWithIdentifier("segueAddPlayer", sender: self)
    }
    func loadPlayers()
    {
        playerArr.removeAll()
        PlayerModel().getAllPlayers(){
            returnValue in
            if returnValue.count != 0{
                self.playerArr = returnValue
                self.playerArr.sortInPlace({$0.name < $1.name})
                self.PlayerTV.reloadData()
            }
        }
    }
    func reloadPlayers(notification: NSNotification)
    {
        loadPlayers()
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
        return playerArr.count
    }
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let delete = UITableViewRowAction(style: .Destructive, title: "Slet")
        {   action, indexPath in
            self.deletePlayerIndexPath = indexPath
            let player = self.playerArr[indexPath.row].getName()
            self.confirmDelete(player)
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if loginObj.getStatus() == 1
        {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }

        cell.textLabel!.text = playerArr[indexPath.row].getName()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        // Admin status is 1
        if loginObj.getStatus() == 1
        {
            playerObject = playerArr[indexPath.row]
            self.performSegueWithIdentifier("segueEditPlayer", sender: self)
        }
    }
    
    // MARK: - Alert
    
    func confirmDelete(player: String)
    {
        let alert = UIAlertController(title: "Slet spiller", message: "Er du sikker på at du vil slette spilleren \"\(player)\" permanent?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Slet", style: .Destructive, handler: handleDeletePlayer)
        let CancelAction = UIAlertAction(title: "Annuller", style: .Cancel, handler: cancelDeletePlayer)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func handleDeletePlayer(alertAction: UIAlertAction!) -> Void
    {
        if let indexPath = deletePlayerIndexPath
        {
            PlayerTV.beginUpdates()
            
            PlayerModel().deletePlayer(self.playerArr[indexPath.row].getId())
            {
                NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
            }
            
            PlayerTV.endUpdates()
        }
    }
    
    func cancelDeletePlayer(alertAction: UIAlertAction!)
    {
        deletePlayerIndexPath = nil
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let editPlayerVC = segue.destinationViewController as? EditPlayerVC
        if segue.identifier == "segueEditPlayer"
        {
            editPlayerVC?.playerObject = playerObject
        }
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
    {
        return false
    }

}
