//
//  MoreDetailEventsTableViewCellTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 30/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class MoreDetailEventsTableViewCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var optionImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var obsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(userOption: DetailEventsViewController.MoreDetailEventsOption) {
        
        self.titleLabel.text = userOption.title
        self.subtitleLabel.text = userOption.subtitle
        self.obsLabel.text = userOption.obs?.uppercased()
        
        self.optionImageView.tintColor = userOption.imageColor
        
        self.accessoryType = userOption.hasMore == true ? .disclosureIndicator : .none
        self.selectionStyle = userOption.hasMore == true ? .default : .none
        
        self.tagLabel.text = userOption.tag?.uppercased()
        self.tagLabel.textColor = userOption.tagColor == nil ? self.obsLabel.textColor : userOption.tagColor
    }
}

extension MoreDetailEventsTableViewCellTableViewCell {
    
    func loadImage(itemImage: String?, emptyImage: UIImage, isEmpty: Bool?, tableView: UITableView, indexPath: IndexPath) {
        
        if let url = URL(string: itemImage ?? "") {
            self.optionImageView.kf.setImage(with: url)
        } else {
            self.optionImageView.image = emptyImage
        }
    }
}
