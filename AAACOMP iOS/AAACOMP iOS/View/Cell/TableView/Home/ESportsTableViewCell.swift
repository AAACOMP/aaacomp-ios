//
//  ESportsTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 17/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class ESportsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var playersLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var esportImageView: UIImageView!
    
    var isReloaded: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCell(title: String?, description: String?, players: String?) {
        
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        self.playersLabel.text = players
    }
}
