//
//  TimerCell.swift
//  Malsha_C0871063_LabTest
//
//  Created by Malsha Lambton on 2022-11-04.
//

import UIKit

class TimerCell: UITableViewCell {
    
    @IBOutlet var timerValueLabel : UILabel?
    @IBOutlet var lapCountLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
