//
//  StatusAssociationTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 16/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class StatusAssociationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var associationTypeLabel: UILabel!
    @IBOutlet weak var associationTypeImage: UIImageView!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var paymentStatusLabel: UILabel!
    @IBOutlet weak var associationValueLabel: UILabel!
    @IBOutlet weak var associationStatusLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCell(associationType: String?, paymentType: String?, paymentStatus: String?, associationValue: String?, image: UIImage?) {
        
        self.associationTypeLabel.text = associationType
        self.paymentTypeLabel.text = paymentType
        self.paymentStatusLabel.text = paymentStatus
        self.associationValueLabel.text = associationValue
        self.associationTypeImage.image = image
    }
}
