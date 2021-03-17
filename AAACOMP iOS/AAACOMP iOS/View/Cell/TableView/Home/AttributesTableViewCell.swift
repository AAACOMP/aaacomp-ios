//
//  AttributesTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 30/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class AttributesTableViewCell: UITableViewCell {

    @IBOutlet weak private var leftLabel: UILabel!
    @IBOutlet weak private var rightLabel: UILabel!
    @IBOutlet weak private var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(left: String?, right: String?, hex: String?, isTitleLeft: Bool) {
        
        self.leftLabel.text = left
        self.rightLabel.text = right
        self.separatorView.backgroundColor = UIColor.hexStringToUIColor(hex: hex ?? "")
        
        if isTitleLeft {
            self.leftLabel.font = .systemFont(ofSize: 17, weight: .black)
            self.rightLabel.font = .systemFont(ofSize: 16)
        }
        
        else {
            self.rightLabel.font = .systemFont(ofSize: 17, weight: .black)
            self.leftLabel.font = .systemFont(ofSize: 16)
        }
    }

}
