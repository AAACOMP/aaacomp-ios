//
//  EventsTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 29/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setCell(event: EventsCodable) {
        
        self.tagLabel.text = event.isParty == true ? "FESTA" : "OUTRO"
        
        self.titleLabel.text = event.name
        self.dateLabel.text = "\(event.date ?? "")\n\(event.time ?? "")"
        self.descriptionLabel.text = event.description
    }
}
