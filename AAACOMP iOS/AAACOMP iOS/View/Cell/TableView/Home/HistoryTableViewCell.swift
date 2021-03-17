//
//  HistoryTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 30/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(history: String?, tag: Int) {
        
        self.historyLabel.text = history
        self.showMoreButton.tag = tag
    }
}
