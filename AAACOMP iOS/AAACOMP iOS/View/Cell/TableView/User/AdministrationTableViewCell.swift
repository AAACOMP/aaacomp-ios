//
//  AdministrationTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 14/06/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class AdministrationTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var crownImage: UIImageView!
    
    func setCell(user: UserCodable?, paymentStatus: [PaymentStatusCodable]){
        
        let status = paymentStatus.first(where: {$0.uuid == user?.paymentStatusUUID})
        
        self.statusLabel.text = status?.name?.uppercased()
        self.statusLabel.textColor = status?.uuid == "d55b340c-8584-4d22-b16c-ae72fd0607c0" ? .systemOrange : status?.uuid == "4b22c3aa-1fca-4b26-b1e6-8f6086e61030" ? .systemGreen : status?.uuid == "24d21b70-1856-4e8e-a576-2b335f2d0112" ? .systemRed : .lightGray
        
        self.nameLabel.text = user?.completeName
        self.descriptionLabel.text = "\(user?.email ?? "")\nContato: \(user?.contact?.applyMask(.phone) ?? "")"
        
        self.creditsLabel.text = user?.credits ?? -1 >= 0 ? "\(user?.credits ?? 0) PONTOS" : nil
        self.creditsLabel.alpha = user?.credits ?? -1 >= 0 ? 1 : 0
        
        if user?.isAdm == true { self.crownImage.alpha = 1 }
        else { self.crownImage.alpha = 0 }
    }
}
