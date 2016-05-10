//
//  EditFineVC.swift
//  Pay the team
//
//  Created by Mik Jensen on 28/03/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class EditFineVC: UIViewController
{
    
    @IBOutlet weak var fineTitleTF: UITextField!
    @IBOutlet weak var finePriceTF: UITextField!
    var fineObject:NSObject?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        let fine = fineObject as! Fine
        
        fineTitleTF.text = fine.GetTitle()
        finePriceTF.text = "\(fine.GetPrice())"
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editFineAction(sender: AnyObject)
    {
        let fine = fineObject as! Fine
        FineModel().UpdateFine(fine.GetTitle(), newTitle: fineTitleTF.text!, price: Int(finePriceTF.text!)!)
        {
            NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
            
            JLToast.makeText("Bøden er ændret", duration: JLToastDelay.ShortDelay).show()
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
