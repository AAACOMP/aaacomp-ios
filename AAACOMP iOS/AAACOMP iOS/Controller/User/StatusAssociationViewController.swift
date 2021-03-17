//
//  StatusAssociationViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 16/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import Firebase

class StatusAssociationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var user: UserCodable?
    private var association: AssociationCodable?
    private var paymentTypes: [PaymentTypesCodable] = []
    private var paymentStatus: [PaymentStatusCodable] = []
    private var associationStatus: [AssociationStatusCodable] = []
    private var images: [String: UIImage] = [:]
    var userUID: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser == nil { self.navigationController?.popViewController(animated: true) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.userUID != "" { self.loadData() }
    }
    
    func loadData() {
        
        Download.observeUser(uid: self.userUID) { (user, alert) in
            DispatchQueue.main.async {
                if alert.isSuccess { self.user = user }
                else { alert.show(controller: self) }
                self.tableView.reloadData()
                
                Download.observeValues(databaseKey: .association) { (any, alert) in
                    DispatchQueue.main.async {
                        if alert.isSuccess { self.association = any as? AssociationCodable }
                        else { alert.show(controller: self) }
                        self.tableView.reloadData()
                        
                        let associationType = self.association?.types?.first(where: {$0.uuid == user?.associationTypeUUID})
                        
                        if associationType != nil {
                            
                            Download.images(urls: [associationType?.image ?? ""]) { (images, alert) in
                                DispatchQueue.main.async {
                                    if alert.isSuccess { self.images = images }
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
                
                Download.observeValues(databaseKey: .paymentTypes) { (any, alert) in
                    DispatchQueue.main.async {
                        if alert.isSuccess { self.paymentTypes = any as? [PaymentTypesCodable] ?? [] }
                        else { alert.show(controller: self) }
                        self.tableView.reloadData()
                    }
                }
                
                Download.observeValues(databaseKey: .paymentStatus) { (any, alert) in
                    DispatchQueue.main.async {
                        if alert.isSuccess { self.paymentStatus = any as? [PaymentStatusCodable] ?? [] }
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
            }
        }
    }
}

// MARK: - TableView

extension StatusAssociationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 { return 1 }
        else if section == 1 { return self.paymentTypes.count }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .statusAssociation), for: indexPath) as? StatusAssociationTableViewCell else { return UITableViewCell() }
            
            let validate = associationStatus.filter({$0.isValidate == true}).first(where: {user?.associationStatusUUID?.contains($0.uuid ?? "") ?? false})
            let associationType = association?.types?.first(where: {$0.uuid == user?.associationTypeUUID})
            let statusPayment = paymentStatus.first(where: {$0.uuid == user?.paymentStatusUUID})
            let typePayment = paymentTypes.first(where: {$0.uuid == user?.paymentTypeUUID})
            
            let associationValue = (self.user?.associationStatusUUID?.count ?? 0 == 0 && statusPayment?.uuid == "7db8d5ed-ce64-47d0-af4f-f17cdf783f7e") ? "" : (self.user?.associationStatusUUID?.count ?? 0 == 0 && statusPayment?.uuid == "d55b340c-8584-4d22-b16c-ae72fd0607c0") ? associationType?.values?.first?.value ?? "" : (self.user?.associationStatusUUID?.count ?? 0 == 1 && statusPayment?.uuid == "d55b340c-8584-4d22-b16c-ae72fd0607c0") ? associationType?.values?.last?.value ?? "" : (self.user?.associationStatusUUID?.count ?? 0 == 1 && statusPayment?.uuid == "4b22c3aa-1fca-4b26-b1e6-8f6086e61030") ? associationType?.values?.first?.value ?? "" : self.user?.associationStatusUUID?.count ?? 0 > 1 ? associationType?.values?.last?.value ?? "" : ""
            
            cell.setCell(associationType: associationType?.title ?? "Nenhum plano selecionado", paymentType: typePayment?.name ?? "", paymentStatus: statusPayment?.name?.uppercased(), associationValue: associationValue, image: associationType == nil ? #imageLiteral(resourceName: "id-card") : self.images[associationType?.image ?? ""])
            cell.associationStatusLabel.text = (validate == nil ? "Até o momento você não está associado(a)" : "Até o momento você está associado(a)").uppercased()
            cell.statusView.backgroundColor = statusPayment?.uuid == "d55b340c-8584-4d22-b16c-ae72fd0607c0" ? .systemOrange : statusPayment?.uuid == "4b22c3aa-1fca-4b26-b1e6-8f6086e61030" ? .systemGreen : statusPayment?.uuid == "24d21b70-1856-4e8e-a576-2b335f2d0112" ? .systemRed : .systemGray
            
            return cell
        }
        
        else if indexPath.section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .simple), for: indexPath) as? SimpleTableViewCell else { return UITableViewCell() }
            let item = self.paymentTypes[indexPath.row]
            let typePayment = paymentTypes.first(where: {$0.uuid == user?.paymentTypeUUID})
            cell.setCell(title: item.name, description: item.observation?.replacingOccurrences(of: "\\n", with: "\n"))
            if #available(iOS 13.0, *) { cell.titleLabel.textColor = item.uuid == typePayment?.uuid ? .systemTeal : .label }
            else { cell.titleLabel.textColor = item.uuid == typePayment?.uuid ? .systemTeal : .black }
            cell.accessoryType = item.uuid == typePayment?.uuid ? .checkmark : .none
            return cell
        }
        
        return UITableViewCell()
    }
}
