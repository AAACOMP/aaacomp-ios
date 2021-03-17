//
//  AssociationTypeTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 16/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class AssociationTypeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var valueTitle1Label: UILabel!
    @IBOutlet weak var valueTitle2Label: UILabel!
    @IBOutlet weak var value1Label: UILabel!
    @IBOutlet weak var value2Label: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isReloaded: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(type: TypesAssociationCodable?) {
        
        self.titleLabel.text = type?.title?.uppercased()
        
        self.valueTitle1Label.text = type?.values?.first?.title?.uppercased()
        self.value1Label.text = type?.values?.first?.value
        
        self.valueTitle2Label.text = type?.values?.last?.title?.uppercased()
        self.value2Label.text = type?.values?.last?.value
        
        var description = ""
        
        type?.benefits?.forEach({ (benefit) in
            description = description + "• \(benefit)\n"
        })
        
        self.descriptionLabel.text = description
    }

}
