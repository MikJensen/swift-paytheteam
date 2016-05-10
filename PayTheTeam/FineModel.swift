//
//  FineModel.swift
//  Pay the team
//
//  Created by Mik Jensen on 23/03/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit
import Firebase

class FineModel: NSObject
{
    
    let loginObj = KeychainWrapper.objectForKey("IsLoggedIn") as! Login
    
    func GetAllFines(ch:(returnValue: Array<Fine>)->Void)
    {
        var fineArr = [Fine]()
        let ref = Firebase(url: "https://paytheteam.firebaseio.com/Teams/\(self.loginObj.getTeam())/")
        
        ref.observeEventType(.ChildAdded, withBlock:
        {
            snapshot in
            
            if snapshot.key == "Fines"
            {
                for child in snapshot.children
                {
                    let childSnapshot = snapshot.childSnapshotForPath(child.key)
                    let title = childSnapshot.key as String
                    let price = childSnapshot.value.objectForKey("price") as! Int
                    fineArr.append(Fine(title: title, price: price))
                }
                ch(returnValue: fineArr)
            }
        }, withCancelBlock:
        {
            error in
            print(error.description)
        })
        
    }
    
    func createFine(title:String, price:Int, ch:()->Void)
    {
        let ref = Firebase(url: "https://paytheteam.firebaseio.com/Teams/\(self.loginObj.getTeam())/Fines/")
        
        let fine = ["price": price]
        
        let fineRef = ref.childByAppendingPath(title)
        fineRef.setValue(fine)
        ch()
    }
    
    func UpdateFine(title: String, newTitle: String, price:Int, ch:()->Void)
    {
        let refDelete = Firebase(url: "https://paytheteam.firebaseio.com/Teams/\(self.loginObj.getTeam())/Fines/\(title)/")
        refDelete.removeValue()
        
        let ref = Firebase(url: "https://paytheteam.firebaseio.com/Teams/\(self.loginObj.getTeam())/Fines/")
        
        let fine = ["price": price]
        
        let fineRef = ref.childByAppendingPath(newTitle)
        fineRef.setValue(fine)
        ch()
    }
    
    func DeleteFine(fineTitle: String, ch: () -> Void)
    {
        let ref = Firebase(url: "https://paytheteam.firebaseio.com/Teams/\(self.loginObj.getTeam())/Fines/\(fineTitle)")
        ref.removeValue()
    }
}
