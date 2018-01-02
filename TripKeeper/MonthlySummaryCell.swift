//
//  MonthlySummaryCellTableViewCell.swift
//  TripKeeper
//
//  Created by PYC on 12/29/17.
//  Copyright © 2017 PYC. All rights reserved.
//

import UIKit

class MonthlySummaryCell: UITableViewCell {
    var onButtonTapped: (() -> Void)? = nil
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var numberOfTrips: UILabel!
    @IBOutlet weak var totalMiles: UILabel!
    @IBOutlet weak var sendReportBtn: UIButton!
    @IBOutlet weak var viewTripsDetailsBtn: UIButton!
    
    @IBAction func tripsDetailsBtnTapped(_ sender: UIButton) {
        if let onButtonTapped = self.onButtonTapped{
            onButtonTapped()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
