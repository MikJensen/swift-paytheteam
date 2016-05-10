//
//  PlayerModel.swift
//  Pay the team
//
//  Created by Mik Jensen on 16/03/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit
import Firebase

class PlayerModel: NSObject
{
    let loginObj = KeychainWrapper.objectForKey("IsLoggedIn") as! Login
    let ref = Firebase(url: "https://paytheteam.firebaseio.com/Players/")
    
    func getPlayer(ch:(returnValue: Player)->Void){
        ref.observeEventType(.ChildAdded, withBlock: {
            snapshot in
            if snapshot.key == self.loginObj.getPlayer(){
                let id = snapshot.key
                let name = snapshot.value.objectForKey("name") as! String
                let mail = snapshot.value.objectForKey("email") as! String
                let number = snapshot.value.objectForKey("number") as! String
                let status = snapshot.value.objectForKey("status") as! Int
                
                self.getOwsOfPlayer(id)
                {
                    returnValueOw in
                    
                    ch(returnValue: Player(id: id, name: name, number: number, mail: mail, status: status, ows: returnValueOw))
                }
            }
        }, withCancelBlock:{
            error in
            print(error.description)
        })
    }
    func getAllPlayers(ch:(returnValue: Array<Player>)->Void)
    {
        var playerArr = [Player]()
        
        ref.observeEventType(.ChildAdded, withBlock:
        {
            snapshot in
            let team = snapshot.value.objectForKey("teamId") as! String
            if team == self.loginObj.getTeam()
            {
                let id = snapshot.key
                let name = snapshot.value.objectForKey("name") as! String
                let mail = snapshot.value.objectForKey("email") as! String
                let number = snapshot.value.objectForKey("number") as! String
                let status = snapshot.value.objectForKey("status") as! Int
                
                self.getOwsOfPlayer(id)
                {
                    returnValueOw in
                    playerArr.append(Player(id: id, name: name, number: number, mail: mail, status: status, ows: returnValueOw))
                    ch(returnValue: playerArr)
                }
                
            }
        }, withCancelBlock:
        {
            error in
            print(error.description)
        })
        
    }
    func getOwsOfPlayer(playerId: String, ch:(returnValueOw: Array<Ows>)->Void)
    {
        var owArr = [Ows]()
        let ref = Firebase(url: "https://paytheteam.firebaseio.com/Players/\(playerId)/")
        ref.observeEventType(.Value, withBlock:
        {
            snapshot in
            if snapshot.value.objectForKey("Ow") != nil
            {
                let ow = snapshot.childSnapshotForPath("Ow")!
                for child in ow.children
                {
                    let childSnapshot = ow.childSnapshotForPath(child.key)
                    let date = childSnapshot.key as String
                    let price = childSnapshot.value.objectForKey("price") as! Int
                    let title = childSnapshot.value.objectForKey("title") as! String
                    owArr.append(Ows(title: title, price: price, date:date))
                }
            }
            ch(returnValueOw: owArr)
        }, withCancelBlock:
        {
            error in
            print("error: \(error.description)")
        
        })
    }
    func createPlayer(playerMail:String, playerName:String, playerNumber:String, playerPass:String, playerStatus:Int, ch:(returnValue: Bool)->Void)
    {

        ref.createUser(playerMail, password: playerPass, withValueCompletionBlock:
        {
            error, result in
            if error == nil
            {
                self.ref.authUser(playerMail, password: playerPass, withCompletionBlock:
                {
                    error, AuthData in
                    if error == nil
                    {
                        let player = ["name" : playerName, "email": playerMail, "number": playerNumber, "teamId": self.loginObj.getTeam(), "status": playerStatus]
                        let playerRef = self.ref.childByAppendingPath(AuthData.uid)
                        
                        playerRef.setValue(player)
                        ch(returnValue: true)
                    }
                })
            }
            else
            {
                ch(returnValue: false)
            }
        })
    }
    func updatePlayer(playerId: String, playerMail:String, playerName:String, playerNumber:String, playerStatus:Int)
    {
        let player = ["name" : playerName, "email": playerMail, "number": playerNumber, "teamId": self.loginObj.getTeam(), "status": playerStatus]
        print(playerId)
        let playerRef = ref.childByAppendingPath(playerId)
        playerRef.updateChildValues(player as [NSObject : AnyObject])
    }
    
    func deletePlayer(playerId: String, ch: () -> Void)
    {
        let itemRef = ref.childByAppendingPath(playerId)
        itemRef.removeValue()
    }
    
    func assignFineToPlayer(fine: NSObject, playerId: String)
    {
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        let DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
        
        let fineObj = fine as? Fine
        let ref = Firebase(url: "https://paytheteam.firebaseio.com/Players/\(playerId)/Ow/")
        let title = fineObj?.GetTitle()
        let price = Int((fineObj?.GetPrice())!)
        let ow : [String : AnyObject] = ["title": title!, "price": price]
        let owRef = ref.childByAppendingPath(DateInFormat)
        owRef.setValue(ow)
    }
}
