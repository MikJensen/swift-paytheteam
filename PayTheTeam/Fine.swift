//
//  Fine.swift
//  Pay the team
//
//  Created by Mik Jensen on 23/03/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class Fine: NSObject
{
    var title:String
    var price:Int
    
    init(title:String, price:Int)
    {
        self.title = title
        self.price = price
    }
    func GetTitle() -> String
    {
        return self.title
    }
    func GetPrice() -> Int
    {
        return self.price
    }
    func SetTitle(title:String)
    {
        self.title = title
    }
    func SetPrice(price:Int)
    {
        self.price = price
    }
}
