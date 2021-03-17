//
//  AssociationTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 16/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class AssociationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(description: String?, banner: UIImage?) {
        
        self.descriptionLabel.text = description?.replacingOccurrences(of: "\\n", with: "\n")
        self.banner.image = banner
        
        self.layoutIfNeeded()
        self.heightConstraint.constant = self.banner.image == nil || self.banner.image == UIImage() ? 0 : self.banner.resize()
        
        UIView.animate(withDuration: 0.4, animations: { self.layoutIfNeeded() })
    }
}
