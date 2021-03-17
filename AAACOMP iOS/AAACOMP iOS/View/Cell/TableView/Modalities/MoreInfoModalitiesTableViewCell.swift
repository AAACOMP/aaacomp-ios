//
//  MoreInfoModalitiesTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 14/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class MoreInfoModalitiesTableViewCell: UITableViewCell {

    @IBOutlet weak var moreInfoImageView: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var isReloaded: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCell(moreInfo: MoreInfoModalitiesCodable?) {
        
        self.titleLabel.text = moreInfo?.description
        self.descriptionLabel.text = moreInfo?.address
    }
}
