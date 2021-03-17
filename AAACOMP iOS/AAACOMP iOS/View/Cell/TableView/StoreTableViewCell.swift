//
//  StoreTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 30/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class StoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCell(products: StoreCodable?) {
        
        self.titleLabel.text = products?.title
        self.descriptionLabel.text = "\(products?.description ?? "Sem descrição")"
        self.periodLabel.text = products?.isOpen == true ? "ESSE PRODUTO AINDA ESTÁ À VENDA" : "O PRAZO FOI ENCERRADO PARA COMPRA DESSE PRODUTO"
        self.periodLabel.textColor = products?.isOpen == true ? .systemGreen : .systemGray
    }
}
