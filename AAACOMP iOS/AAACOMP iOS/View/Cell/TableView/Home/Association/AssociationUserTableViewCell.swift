//
//  AssociationUserTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 16/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class AssociationUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCell(name: String?, description: String?, image: UIImage?) {
        
        self.nameLabel.text = name?.capitalized
        self.descriptionLabel.text = description
        self.userImage.image = image
    }
}
