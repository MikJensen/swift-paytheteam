//
//  AddPlayerVC.swift
//  Pay the team
//
//  Created by Mik Jensen on 04/04/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit
import CloudKit
import MessageUI

class AddPlayerVC: UIViewController, MFMessageComposeViewControllerDelegate
{

    @IBOutlet weak var statusPicker: UIPickerView!
    
    @IBOutlet weak var NumberTF: UITextField!
    @IBOutlet weak var MailTF: UITextField!
    @IBOutlet weak var NameTF: UITextField!
    var statusArr = ["Spiller", "Administrator"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //print(CreatePassword("Mik Jensen", number: "12345678"))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CreatePlayerAction(sender: AnyObject)
    {
        let mail = MailTF.text!
        let name = NameTF.text!
        let number = NumberTF.text!
        let statusSelected = statusPicker.selectedRowInComponent(0)
        
        PlayerModel().createPlayer(mail, playerName: name, playerNumber: number, playerPass: CreatePassword(name, number:number), playerStatus: statusSelected){
            returnValue in
            if returnValue
            {
                self.MailTF.text = ""
                self.NameTF.text = ""
                self.NumberTF.text = ""
//                let messageVC = MFMessageComposeViewController()
//                
//                messageVC.body = "Hej \(name)\nDu er blevet oprettet i Pay The Team.\n\nBrugernavn: \(mail)\nKodeord: \(self.CreatePassword(name, number:number))\n\nMvh Admin"
//                messageVC.recipients = ["0045\(number)"]
//                messageVC.messageComposeDelegate = self
                
                NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
                
                JLToast.makeText("Spiller er oprettet", duration: JLToastDelay.ShortDelay).show()
            }
            else
            {
                JLToast.makeText("Spiller er ikke oprettet, prøv igen!", duration: JLToastDelay.ShortDelay).show()
            }
        }
        
        
        // Kan ikke bruges i emulatoren
        //self.presentViewController(messageVC, animated: false, completion: nil)
    }
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult)
    {
        switch result.rawValue
        {
        case MessageComposeResultCancelled.rawValue:
            print("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.rawValue:
            print("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.rawValue:
            print("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }
    func CreatePassword(name: String, number:String) -> String
    {
        let newName = name.stringByReplacingOccurrencesOfString(" ", withString: "")
        let password = "\(newName)\(number)"
        return password
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
