//
//  Player.swift
//  Pay the team
//
//  Created by Mik Jensen on 04/04/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class Player: NSObject
{
    let id:String
    let name:String
    let number:String
    let mail:String
    let status:Int
    let ows:Array<Ows>
    
    init(id: String, name:String, number:String, mail:String, status:Int, ows:Array<Ows>)
    {
        self.id = id
        self.name = name
        self.number = number
        self.mail = mail
        self.status = status
        self.ows = ows
    }
    func getId() -> String
    {
        return self.id
    }
    func getName() -> String
    {
        return self.name
    }
    func getNumber() -> String
    {
        return self.number
    }
    func getMail() -> String
    {
        return self.mail
    }
    func getStatus() -> Int
    {
        return self.status
    }
    func getOws() -> Array<Ows>
    {
        return self.ows
    }
}
