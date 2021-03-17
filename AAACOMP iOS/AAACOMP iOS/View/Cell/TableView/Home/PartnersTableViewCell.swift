//
//  PartnersTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 31/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class PartnersTableViewCell: UITableViewCell {

    @IBOutlet weak var partnerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCell(partner: PartnersCodable) {
        
        self.titleLabel.text = partner.name
        self.descriptionLabel.text = partner.description
    }
}
