//
//  TableViewCell.swift
//  Pay the team
//
//  Created by Mik Jensen on 28/03/2016.
//  Copyright © 2016 Mik Jensen. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell
{

    @IBOutlet weak var priceLbl: UILabel!

    @IBOutlet weak var fineText: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        fineText.lineBreakMode = .ByWordWrapping
        fineText.numberOfLines = 0;
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
