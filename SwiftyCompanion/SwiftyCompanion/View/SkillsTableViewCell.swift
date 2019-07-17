//
//  SkillsTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Serhii CHORNONOH on 7/12/19.
//  Copyright © 2019 Serhii CHORNONOH. All rights reserved.
//

import UIKit

class SkillsTableViewCell: UITableViewCell {

    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var skillProgressBar: UIProgressView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        skillProgressBar.layer.cornerRadius = (skillProgressBar.frame.height / 2) * 2
        skillProgressBar.clipsToBounds = true
        skillProgressBar.layer.sublayers![1].cornerRadius = (self.skillProgressBar.frame.height / 2) * 2
        skillProgressBar.subviews[1].clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
