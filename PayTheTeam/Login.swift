//
//  Login.swift
//  Pay the team
//
//  Created by Mik Jensen on 16/03/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class Login: NSObject, NSCoding
{
    let player:String
    let team:String
    let status:Int
    
    init(player: String, team: String, status:Int)
    {
        self.player = player
        self.team = team
        self.status = status
    }
    func getPlayer()->String
    {
        return self.player
    }
    func getTeam()->String
    {
        return self.team
    }
    func getStatus()->Int
    {
        return self.status
    }
    // MARK: NSCoding
    
    required convenience init?(coder decoder: NSCoder)
    {
        guard let player = decoder.decodeObjectForKey("player") as? String,
            let team = decoder.decodeObjectForKey("team") as? String,
            let status = decoder.decodeObjectForKey("status") as? Int
        else
        {
            return nil
        }
        
        self.init(player: player, team: team, status: status)
    }
    
    func encodeWithCoder(coder: NSCoder)
    {
        coder.encodeObject(self.player, forKey: "player")
        coder.encodeObject(self.team, forKey: "team")
        coder.encodeObject(self.status, forKey: "status")
    }
}
