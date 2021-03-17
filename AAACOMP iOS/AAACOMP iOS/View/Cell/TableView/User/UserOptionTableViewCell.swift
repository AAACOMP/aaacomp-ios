//
//  UserOptionTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 14/06/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class UserOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var optionImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var obsLabel: UILabel!
    
    func setCell(userOption: UserViewController.UserOption) {
        
        self.titleLabel.text = userOption.title
        self.subtitleLabel.text = userOption.subtitle
        self.obsLabel.text = userOption.obs?.uppercased()
        
        self.optionImageView.image = userOption.image
        self.optionImageView.tintColor = userOption.imageColor
        
        self.accessoryType = userOption.hasMore == true ? .disclosureIndicator : .none
        self.selectionStyle = userOption.hasMore == true ? .default : .none
        
        self.tagLabel.text = userOption.tag?.uppercased()
        self.tagLabel.textColor = userOption.tagColor == nil ? self.obsLabel.textColor : userOption.tagColor
    }
}
