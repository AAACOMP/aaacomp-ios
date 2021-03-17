//
//  DepositionCollectionViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 17/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class DepositionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var depositionImage: UIImageView!
    
    func setCell(title: String?, subtitle: String?, description: String?) {
        
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.descriptionLabel.text = description
    }
}
