//
//  InstillingerVC.swift
//  Pay the team
//
//  Created by Mik Jensen on 23/03/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class InstillingerVC: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogOut(sender: AnyObject)
    {
        KeychainWrapper.removeObjectForKey("IsLoggedIn")
        performSegueWithIdentifier("segueLogout", sender: self)
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
    {
        return false
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
