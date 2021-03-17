//
//  DetailEventsTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 31/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class DetailEventsTableViewCell: UITableViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(event: EventsCodable?) {
        
        self.tagLabel.text = event?.isParty == true ? "FESTA" : "OUTRO"
        
        self.dateLabel.text = "\(event?.date ?? "")\n\(event?.time ?? "")"
        self.titleLabel.text = event?.name
        self.addressLabel.text = event?.address
        self.descriptionLabel.text = event?.description
    }
}
