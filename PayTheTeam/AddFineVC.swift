//
//  AddFineVC.swift
//  Pay the team
//
//  Created by Mik Jensen on 29/03/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit
import CloudKit

class AddFineVC: UIViewController
{

    @IBOutlet weak var titleFineTF: UITextField!
    @IBOutlet weak var priceFineTF: UITextField!
    
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
    
    @IBAction func addFineAction(sender: AnyObject)
    {
        if titleFineTF.text != "" && priceFineTF.text != ""
        {
            FineModel().createFine(titleFineTF.text!, price: Int(priceFineTF.text!)!)
            {
                self.titleFineTF.text = ""
                self.priceFineTF.text = ""
                NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
                
                JLToast.makeText("Bøden er oprettet", duration: JLToastDelay.ShortDelay).show()
            }
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
