//
//  TeamModel.swift
//  Pay the team
//
//  Created by Mik Jensen on 16/03/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit
import Firebase

class TeamModel: NSObject {

    func CreateTeam(teamName: String, playerName: String, playerMail: String, playerPass: String, playerNumber: String, playerStatus: Int, completionHandler ch: (returnValue: Bool) -> Void)
    {
        let uniqueId = NSUUID().UUIDString
        let teamRef = Firebase(url: "https://paytheteam.firebaseio.com/Teams/\(uniqueId)/")
        let team = ["name": teamName]
        teamRef.setValue(team)
        let ref = Firebase(url: "https://paytheteam.firebaseio.com/Players/")
        ref.createUser(playerMail, password: playerPass, withValueCompletionBlock:
        {
            error, result in
            if error == nil
            {
                let player = ["name" : playerName, "email": playerMail, "number": playerNumber, "teamId": uniqueId, "status": playerStatus]
                let uuid = result["uid"] as? String
                let playerRef = ref.childByAppendingPath(uuid)
                playerRef.setValue(player)
                ch(returnValue: true)
                print("User created")
            }
            else
            {
                ch(returnValue: false)
                print("User not created")
            }
        })
    }
    func getTeamName(ch: (returnValue: String)->Void)
    {
        let loginObj = KeychainWrapper.objectForKey("IsLoggedIn") as! Login
        print(loginObj.getTeam())
        let ref = Firebase(url: "https://paytheteam.firebaseio.com/Teams/\(loginObj.getTeam())/")
        ref.observeEventType(.ChildAdded, withBlock:
        {
            snapshot in
            //print("Key: \(snapshot.key)")
            let name = snapshot.value.objectForKey("name") as! String
            ch(returnValue: name)
            }, withCancelBlock:
            {
                error in
                ch(returnValue: "")
                print(error.description)
        })
    }
}
