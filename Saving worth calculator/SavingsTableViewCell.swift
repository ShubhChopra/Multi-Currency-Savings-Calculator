//
//  SavingsTableViewCell.swift
//  Saving worth calculator
//
//  Created by Shubh Chopra on 8/17/17.
//  Copyright © 2017 Shubh Chopra. All rights reserved.
//

import UIKit

class SavingsTableViewCell: UITableViewCell {


    @IBOutlet weak var backgroundViewCard: UIView!
    @IBOutlet weak var DailyIntrestGainReferenceCurrency: UILabel!
    @IBOutlet weak var DailyIntrestGain: UILabel!
    @IBOutlet weak var completionProgress: UIProgressView!
    @IBOutlet weak var intrestLabel: UILabel!
    @IBOutlet weak var referencedCurrency: UILabel!
    @IBOutlet weak var currentCurrency: UILabel!
    @IBOutlet weak var currentAmountReferenced: UILabel!
    @IBOutlet weak var currentAmountOrignal: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
