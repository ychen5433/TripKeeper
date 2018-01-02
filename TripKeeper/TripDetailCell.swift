//
//  tripTableViewCell.swift
//  TripKeeper
//
//  Created by PYC on 12/27/17.
//  Copyright © 2017 PYC. All rights reserved.
//

import UIKit

class TripDetailCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
