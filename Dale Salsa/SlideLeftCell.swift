//
//  SlideLeftCell.swift
//  Dale Salsa
//
//  Created by Alex Hudson on 11/28/16.
//  Copyright © 2016 HudsonAppls. All rights reserved.
//

import UIKit

class SlideLeftCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 4
        containerView.clipsToBounds = true
        label?.text = NSLocalizedString("sideMenu-viewController.slide-label.text", comment: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
