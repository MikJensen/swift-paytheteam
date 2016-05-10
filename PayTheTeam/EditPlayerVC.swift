//
//  EditPlayerVC.swift
//  Pay the team
//
//  Created by Mik Jensen on 04/04/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class EditPlayerVC: UIViewController, UIPopoverPresentationControllerDelegate
{
    
    var playerObject:NSObject?
    var statusArr = ["Spiller", "Administrator"]
    
    @IBOutlet weak var statusPicker: UIPickerView!
    
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var mailTF: UITextField!
    
    let loginObj = KeychainWrapper.objectForKey("IsLoggedIn") as! Login
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let playerObj = playerObject as! Player
        
        if playerObj.getId() == loginObj.getPlayer(){
            statusPicker.userInteractionEnabled = false
        }
        statusPicker.selectRow(playerObj.getStatus(), inComponent: 0, animated: true)
        nameTF.text = playerObj.getName()
        mailTF.text = playerObj.getMail()
        numberTF.text = playerObj.getNumber()
        //let player = playerObject as! Player

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return statusArr[row]
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return statusArr.count
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    @IBAction func editPlayer(sender: AnyObject)
    {
        let playerObj = playerObject as! Player
        if nameTF.text != "" && mailTF.text != "" && numberTF.text != ""
        {
            PlayerModel().updatePlayer(playerObj.getId(), playerMail: mailTF.text!, playerName: nameTF.text!, playerNumber: numberTF.text!, playerStatus: statusPicker.selectedRowInComponent(0))
            
                JLToast.makeText("Spiller er redigeret", duration: JLToastDelay.ShortDelay).show()
                NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
        }
    }

    @IBAction func assignFine(sender: AnyObject)
    {
        self.performSegueWithIdentifier("seguePopoverFines", sender: self)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "seguePopoverFines"
        {
            let vc = segue.destinationViewController as! UITableViewController
            let addFineToPlayerVC = segue.destinationViewController as? AddFineToPlayerVC
            addFineToPlayerVC?.playerObject = playerObject
            
            let controller = vc.popoverPresentationController
            
            if controller != nil
            {
                controller?.delegate = self
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .None
    }

}
