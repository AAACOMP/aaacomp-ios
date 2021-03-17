//
//  DetailModalitiesViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 14/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class DetailModalitiesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var victories: [VictoriesCodable] = []
    var modality: ModalitiesCodable?
    var responsible: ResponsibleCodable?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = modality?.name
        
        Download.observeValues(databaseKey: .victories) { (any, alert) in
            
            DispatchQueue.main.async {
                
                if alert.isSuccess {
                    
                    self.victories = (any as? [VictoriesCodable] ?? []).filter({ (victory) -> Bool in
                        return self.modality?.victoriesUUID?.contains(victory.uuid ?? "") ?? false
                    })
                }
                    
                else { alert.show(controller: self) }
                
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func sendMessageButtonAction(_ sender: UIButton) {
        
        guard let whatsappURL = URL(string: "whatsapp://send?phone=55\(self.responsible?.phone?.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "") ?? "")") else { return }
        if UIApplication.shared.canOpenURL(whatsappURL) { UIApplication.shared.openURL(whatsappURL) }
    }
}

// MARK: - TableView

extension DetailModalitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 { return self.responsible == nil ? 0 : 1 }
        else if section == 1 { return victories.count }
        else if section == 2 { return self.modality?.moreInfo == nil ? 0 : 1 }
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .responsibleModalities), for: indexPath) as? ResponsibleModalitiesTableViewCell else { return UITableViewCell() }
            
            cell.setCell(responsible: self.responsible)
            cell.messageButton.tag = indexPath.row
            cell.messageButton.addTarget(self, action: #selector(self.sendMessageButtonAction(_:)), for: .touchUpInside)
            
            if let url = URL(string: self.responsible?.image ?? "") {
                cell.responsibleImage.kf.setImage(with: url)
            }
            
            else { cell.responsibleImage.image = nil }
            
            return cell
        }
        
        else if indexPath.section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .attributes), for: indexPath) as? AttributesTableViewCell else { return UITableViewCell() }
            
            let item = self.victories[indexPath.row]
            
            if indexPath.row % 2 == 0 { cell.setCell(left: item.championship, right: "\(item.classification ?? "")\n\(item.year ?? "")", hex: "#106BFF", isTitleLeft: true) }
            else { cell.setCell(left: "\(item.classification ?? "")\n\(item.year ?? "")", right: item.championship, hex: "#92C3FF", isTitleLeft: false) }
            
            return cell
        }
            
        else if indexPath.section == 2 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .moreInfoModalities), for: indexPath) as? MoreInfoModalitiesTableViewCell else { return UITableViewCell() }
            
            let item = self.modality?.moreInfo
            
            cell.setCell(moreInfo: item)
            
            if let url = URL(string: item?.image ?? "") {
                
                cell.moreInfoImageView.kf.setImage(with: url, completionHandler: { (image, error, _, _) in
                    if image != nil && image != UIImage() && error == nil {
                        cell.heightConstraint.constant = image?.getScaleHeight(width: cell.moreInfoImageView.frame.width) ?? 0
                        cell.activityIndicator.stopAnimating()
                        if cell.isReloaded == false {
                            cell.isReloaded = true
                            self.tableView.reloadData()
                        }
                    }
                    else {
                        cell.heightConstraint.constant = 0
                        cell.activityIndicator.stopAnimating()
                        if cell.isReloaded == false {
                            cell.isReloaded = true
                            self.tableView.reloadData()
                        }
                    }
                })
            }
                
            else {
                cell.heightConstraint.constant = 0
                cell.activityIndicator.stopAnimating()
            }
            
            return cell
        }
        
        else { return UITableViewCell() }
    }
}
