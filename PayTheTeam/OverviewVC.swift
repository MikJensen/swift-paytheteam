//
//  OverviewVC.swift
//  Pay the team
//
//  Created by Mik Jensen on 27/04/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class OverviewVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var labelTopLeft: UILabel!
    @IBOutlet weak var labelTopRight: UILabel!
    @IBOutlet weak var labelMidLeft: UILabel!
    @IBOutlet weak var labelMidRight: UILabel!
    @IBOutlet weak var labelBottomLeft: UILabel!
    @IBOutlet weak var labelBottomRight: UILabel!
    
    var playerArr = [Player]()
    var playerObject:Player!
    var totalOws = 0
    
    let loginObj = KeychainWrapper.objectForKey("IsLoggedIn") as! Login

    @IBOutlet weak var overViewTV: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        loadPlayers()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OverviewVC.reloadOverview(_:)),name:"reload", object: nil)
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Opdater oversigt")
        refreshControl.addTarget(self, action: #selector(OverviewVC.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        overViewTV.addSubview(refreshControl)
        
        getPlayerOw(loginObj.)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadOverview(notification: NSNotification)
    {
        loadPlayers()
    }
    
    func refresh(sender:AnyObject)
    {
        loadPlayers()
        self.refreshControl?.endRefreshing()
    }
    
    func loadPlayers()
    {
        totalOws = 0
        playerArr.removeAll()
        PlayerModel().getAllPlayers(){
            returnValue in
            if returnValue.count != 0{
                self.playerArr = returnValue
                self.playerArr.sortInPlace({$0.name < $1.name})
                self.overViewTV.reloadData()
                self.loadTotalOws()
            }
        }
    }
    func loadTotalOws(){
        var total = 0
        for player in playerArr{
            total += self.getPlayerOw(player.getOws())
        }
        labelTopRight.text = "\(total) kr."
    }
    func getPlayerOw(ows: Array<Ows>) -> Int
    {
        if ows.count != 0
        {
            var count = 0
            for item in ows
            {
                count = count+item.getPrice()
            }
            return count
        }
        else
        {
            return 0
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return playerArr.count
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
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
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        
        if loginObj.getStatus() == 1
        {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        cell.fineText.text = "\(playerArr[indexPath.row].getName())"
        cell.priceLbl.text = "\(getPlayerOw(playerArr[indexPath.row].getOws())) kr."
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        // Admin status is 1
        if loginObj.getStatus() == 1
        {
            playerObject = playerArr[indexPath.row]
            self.performSegueWithIdentifier("segueEditPlayer", sender: self)
        }
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
