//
//  ModalitiesTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 29/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class ModalitiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var modalityImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var isReloaded: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(modality: ModalitiesCodable, responsible: ResponsibleCodable?) {
        
        self.titleLabel.text = modality.name
        self.subtitleLabel.text = responsible?.name ?? "Nenhum responsável foi definido"
        self.phoneLabel.text = responsible?.phone
    }
}
