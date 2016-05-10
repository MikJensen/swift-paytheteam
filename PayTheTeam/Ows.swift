//
//  Ows.swift
//  PayTheTeam
//
//  Created by Mik Jensen on 02/05/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class Ows: NSObject {
    let title:String
    let price:Int
    let date:String
    
    init(title:String, price:Int, date:String)
    {
        self.title = title
        self.price = price
        self.date = date
    }
    func getTitle() -> String
    {
        return self.title
    }
    func getPrice() -> Int
    {
        return self.price
    }
    func getDate() -> String
    {
        return self.date
    }
}
