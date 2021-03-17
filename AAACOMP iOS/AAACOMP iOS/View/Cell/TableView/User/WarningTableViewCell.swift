//
//  WarningTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 14/06/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class WarningTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var warningImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var responsibleLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var isReloaded: Bool = false
    
    func setCell(warning: WarningCodable) {
        
        self.dateLabel.text = warning.date
        self.tagLabel.text = warning.tag?.uppercased()
        self.tagLabel.textColor = .systemOrange
        self.titleLabel.text = warning.title
        self.messageLabel.text = warning.message
        self.responsibleLabel.text = warning.user
        self.selectionStyle = warning.link?.isEmpty == false ? .default : .none
        self.accessoryType = warning.link?.isEmpty == false && URL(string: warning.link ?? "") != nil ? .disclosureIndicator : .none
    }
}
