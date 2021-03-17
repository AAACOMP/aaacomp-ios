//
//  DetailAdministrationTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 15/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class DetailAdministrationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cpfLabel: UILabel!
    @IBOutlet weak var rgaLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    
    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var paymentTitle: UILabel!
    @IBOutlet weak var paymentImage: UIImageView!
    
    @IBOutlet weak var creditsButton: UIButton!
    @IBOutlet weak var creditsTitle: UILabel!
    
    @IBOutlet weak var statusTagLabel: UILabel!
    @IBOutlet weak var statusDescriptionLabel: UILabel!
    @IBOutlet weak var statusObsLabel: UILabel!
    
    @IBOutlet weak var associationValueLabel: UILabel!
    @IBOutlet weak var associationStatusLabel: UILabel!
    @IBOutlet weak var statusView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(user: UserCodable?) {
        
        self.nameLabel.text = user?.completeName?.capitalized ?? "Não Consta"
        self.cpfLabel.text = user?.cpf?.applyMask(.cpf) ?? "Não Consta"
        self.rgaLabel.text = user?.rga?.applyMask(.rga) ?? "Não Consta"
        self.birthdayLabel.text = user?.birthday?.applyMask(.birthday) ?? "Não Consta"
        self.phoneLabel.text = user?.contact?.applyMask(.phone) ?? "Não Consta"
        self.emailLabel.text = user?.email ?? "Não Consta"
        self.courseLabel.text = user?.course ?? "Não Consta"
        
        if user?.paymentStatusUUID == "4b22c3aa-1fca-4b26-b1e6-8f6086e61030" {
            self.paymentTitle.text = ("Desconfirmar Pagamento").uppercased()
            self.paymentImage.tintColor = .systemRed
        }
        
        else {
            self.paymentTitle.text = ("Confirmar Pagamento").uppercased()
            self.paymentImage.tintColor = .systemTeal
        }
        
        if user?.credits ?? -1 != -1 { self.creditsTitle.text = "ALTERAR PONTUAÇÃO" + "\n\(user?.credits ?? 0) PONTOS" }
    }
}
