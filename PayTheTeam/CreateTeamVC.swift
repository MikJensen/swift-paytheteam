//
//  CreateTeamVC.swift
//  Pay the team
//
//  Created by Mik Jensen on 16/03/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class CreateTeamVC: UIViewController
{
    @IBOutlet weak var TeamNameTF: UITextField!
    @IBOutlet weak var PlayerNameTF: UITextField!
    @IBOutlet weak var NumberTF: UITextField!
    @IBOutlet weak var MailTF: UITextField!
    @IBOutlet weak var PassTF: UITextField!
    @IBOutlet weak var errorLB: UILabel!
    
    var userMail = ""
    
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
    @IBAction func CreateTeamAndAdmin(sender: AnyObject)
    {
        TeamModel().CreateTeam(TeamNameTF.text!, playerName: PlayerNameTF.text!,playerMail: MailTF.text!, playerPass: PassTF.text!, playerNumber: NumberTF.text!, playerStatus: 1)
        {
            returnValue in
            if returnValue
            {
                self.userMail = self.MailTF.text!
                self.performSegueWithIdentifier("segueLogin", sender: self)
            }
            else
            {
                self.TeamNameTF.text = ""
                self.PlayerNameTF.text = ""
                self.NumberTF.text = ""
                self.MailTF.text = ""
                self.PassTF.text = ""
                self.errorLB.text = "Hold og bruger blev ikke oprettet, prøv igen."
            }
        }
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
    {
        return false
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "segueLogin")
        {
            let loginVC = segue.destinationViewController as! LoginVC
            loginVC.userMail = userMail
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
