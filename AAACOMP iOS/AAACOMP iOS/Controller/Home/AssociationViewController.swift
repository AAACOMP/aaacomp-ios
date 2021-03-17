//
//  AssociationViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 16/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import Firebase

class AssociationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var association: AssociationCodable?
    private var user: UserCodable?
    private var associationStatus: [AssociationStatusCodable] = []
    var bannerImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        Download.observeValues(databaseKey: .association) { (any, alert) in
            
            DispatchQueue.main.async {
                
                if alert.isSuccess { self.association = any as? AssociationCodable }
                else { alert.show(controller: self) }
                
                self.tableView.reloadData()
            }
        }
        
        Download.observeValues(databaseKey: .associationStatus) { (any, alert) in
            DispatchQueue.main.async {
                if alert.isSuccess { self.associationStatus = any as? [AssociationStatusCodable] ?? [] }
                else { alert.show(controller: self) }
                self.tableView.reloadData()
            }
        }
        
        if Auth.auth().currentUser != nil {
            
            Download.observeUser(uid: Auth.auth().currentUser?.uid ?? "") { (user, alert) in
                DispatchQueue.main.async {
                    if alert.isSuccess { self.user = user }
                    else { alert.show(controller: self) }
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - TableView

extension AssociationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let validates = self.associationStatus.filter({ $0.isValidate == true })
        let hasValidate = self.user?.associationStatusUUID?.filter({ (statusUUID) -> Bool in
            return validates.contains(where: { $0.uuid == statusUUID })
        })
        
        return hasValidate?.isEmpty != false && validates.isEmpty == false ? 3 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 { return 1 }
        else if section == 1 { return self.association?.types?.count ?? 0 }
        else if section == 2 { return 1 }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .association), for: indexPath) as? AssociationTableViewCell else { return UITableViewCell() }
            cell.setCell(description: "\(self.association?.description ?? "")\n\n\(self.association?.observation ?? "")", banner: self.bannerImage)
            return cell
        }
        
        else if indexPath.section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .associationtype), for: indexPath) as? AssociationTypeTableViewCell else { return UITableViewCell() }
            let item = self.association?.types?[indexPath.row]
            cell.setCell(type: item)
            
            if let url = URL(string: item?.image ?? "") {
                
                cell.typeImage.kf.setImage(with: url, completionHandler: { (image, error, _, _) in
                    if image != nil && image != UIImage() && error == nil {
                        cell.activityIndicator.stopAnimating()
                        if cell.isReloaded == false {
                            cell.isReloaded = true
                            self.tableView.reloadData()
                        }
                    }
                    else {
                        cell.activityIndicator.stopAnimating()
                        if cell.isReloaded == false {
                            cell.isReloaded = true
                            self.tableView.reloadData()
                        }
                    }
                })
            }
                
            else {
                cell.activityIndicator.stopAnimating()
            }
            
            return cell
        }
        
        else if indexPath.section == 2 {
            return tableView.dequeueReusableCell(withIdentifier: self.association?.isOpen == true ? "AssociationOpen" : "AssociationClose") ?? UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let validates = self.associationStatus.filter({ $0.isValidate == true })
        let hasValidate = self.user?.associationStatusUUID?.filter({ (statusUUID) -> Bool in
            return validates.contains(where: { $0.uuid == statusUUID })
        })
        
        if indexPath.section == 2 && self.association?.isOpen == true && hasValidate?.isEmpty != false && validates.isEmpty == false && Auth.auth().currentUser != nil {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "DetailAssociationViewController") as? DetailAssociationViewController else { return }
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        else if indexPath.section == 2 && self.association?.isOpen == true && hasValidate?.isEmpty != false && validates.isEmpty == false && Auth.auth().currentUser == nil {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "UserViewController") as? UserViewController else { return }
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
