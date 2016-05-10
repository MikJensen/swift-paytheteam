//
//  LoginVC.swift
//  Pay the team
//
//  Created by Mik Jensen on 16/03/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class LoginVC: UIViewController
{

    @IBOutlet weak var MailTF: UITextField!
    @IBOutlet weak var PassTF: UITextField!
    var userMail = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if KeychainWrapper.objectForKey("IsLoggedIn") != nil
        {
            self.performSegueWithIdentifier("segueMain", sender: self)
        }
        if userMail != ""
        {
            MailTF.text = userMail
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Login(sender: AnyObject)
    {
        LoginModel().LoginUser(MailTF.text!, password: PassTF.text!)
        {
            returnValue in
            if returnValue
            {
                LoginModel().getUserLogin(self.MailTF.text!, password: self.PassTF.text!)
                {
                    returnValue in
                    
                    KeychainWrapper.setObject(returnValue, forKey: "IsLoggedIn")
                    self.performSegueWithIdentifier("segueMain", sender: self)
                }
            }
            else
            {
                self.PassTF.text = ""
                JLToast.makeText("Brugernavn eller kodeord er forkert!", duration: JLToastDelay.ShortDelay).show()
            }
        }
        
        
    }
    @IBAction func GoToCreateTeam(sender: AnyObject)
    {
        self.performSegueWithIdentifier("segueCreateTeam", sender: self)
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
    {
        return false
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "segueMain")
        {
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
