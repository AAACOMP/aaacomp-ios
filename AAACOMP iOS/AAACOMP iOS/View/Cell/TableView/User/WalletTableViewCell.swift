//
//  WalletTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 14/06/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class WalletTableViewCell: UITableViewCell {

    @IBOutlet weak var associationTypeLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var validateLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    private var controller: WalletViewController!
    
    func setCell(user: UserCodable?, associationStatus: [AssociationStatusCodable], association: AssociationCodable?, controller: WalletViewController) {
        
        let validates = associationStatus.filter({$0.isValidate == true}).first(where: {user?.associationStatusUUID?.contains($0.uuid ?? "") ?? false})
        let associationType = association?.types?.first(where: {$0.uuid == user?.associationTypeUUID})
        
        dataLabel.text = "Nome: \(user?.completeName ?? "")\nRGA: \(user?.rga?.applyMask(.rga) ?? "")\nCurso: \(user?.course ?? "")\nCPF: \(user?.cpf?.applyMask(.cpf) ?? "")".uppercased()
        associationTypeLabel.text = associationType?.title
        validateLabel.text = "VALIDADE: \(validates?.validate ?? "")"
        
        self.controller = controller
    }
}
