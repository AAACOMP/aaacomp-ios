//
//  ResponsibleModalitiesTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 14/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class ResponsibleModalitiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var responsibleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    
    var isReloaded: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCell(responsible: ResponsibleCodable?) {
        
        self.titleLabel.text = responsible?.name?.capitalized
        self.descriptionLabel.text = "\(responsible?.email ?? "")\n\(responsible?.phone ?? "")"
    }
}
