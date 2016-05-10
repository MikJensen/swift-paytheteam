//
//  LoginModel.swift
//  Pay the team
//
//  Created by Mik Jensen on 16/03/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit
import Firebase

class LoginModel: NSObject
{
    let ref = Firebase(url: "https://paytheteam.firebaseio.com/Players/")
    
    func LoginUser(email: String, password: String, ch: (returnValue: Bool)->Void)
    {
        ref.authUser(email, password: password, withCompletionBlock:
        {
            error, AuthData in
            if error == nil
            {
                ch(returnValue: true)
            }
            else
            {
                ch(returnValue: false)
            }
        })
    }
    
    func getUserLogin(email: String, password: String, ch: (returnValue: NSCoding)->Void)
    {
        ref.authUser(email, password: password, withCompletionBlock:
        {
            error, AuthData in
            print("test")
            if error == nil{
                self.ref.observeEventType(.ChildAdded, withBlock:
                {
                    snapshot in
                    if snapshot.key == AuthData.uid
                    {
                        let status = snapshot.value.objectForKey("status")! as! Int
                        let team = snapshot.value.objectForKey("teamId")! as! String
                        print("player: \(AuthData.uid), team: \(team), status: \(status)")
                        ch(returnValue: Login(player: AuthData.uid, team: team, status: status))
                    }
                }, withCancelBlock:
                {
                    error in
                    print(error.description)
                })
            }
        })
    }
}
