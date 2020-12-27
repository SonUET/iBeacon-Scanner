//
//  CustomTableViewCell.swift
//  UET Beacon Scanner
//
//  Created by Duong Son on 11/12/17.
//  Copyright © 2017 Duong Son. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var proximityLabel: UILabel!
    @IBOutlet var rssiLabel: UILabel!
    @IBOutlet var minorLabel: UILabel!
    @IBOutlet var majorLabel: UILabel!
    @IBOutlet var uuidLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
