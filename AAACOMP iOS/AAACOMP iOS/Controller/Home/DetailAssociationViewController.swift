//
//  DetailAssociationViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 16/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import Firebase

class DetailAssociationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var association: AssociationCodable?
    private var paymentTypes: [PaymentTypesCodable] = []
    private var images: [String: UIImage] = [:]
    private var user: UserCodable?
    
    private var isSelectedType: [Bool] = []
    private var isSelectedPayment: [Bool] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser == nil { self.navigationController?.popViewController(animated: true) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            
            Download.observeUser(uid: Auth.auth().currentUser?.uid ?? "") { (user, alert) in
                DispatchQueue.main.async {
                    if alert.isSuccess { self.user = user }
                    else { alert.show(controller: self) }
                    self.tableView.reloadData()
                    
                    Download.images(urls: [self.user?.image ?? ""]) { (images, alert) in
                        DispatchQueue.main.async {
                            if alert.isSuccess { self.images = images }
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            
            Download.observeValues(databaseKey: .association) { (any, alert) in
                DispatchQueue.main.async {
                    
                    if alert.isSuccess {
                        self.association = any as? AssociationCodable
                        self.isSelectedType = []
                        for i in 0...(self.association?.types?.count ?? 0 == 0 ? 0 : (self.association?.types?.count ?? 0) - 1) { self.isSelectedType.append(i == 0 ? true : false) }
                    }
                    else { alert.show(controller: self) }
                    self.tableView.reloadData()
                }
            }
            
            Download.observeValues(databaseKey: .paymentTypes) { (any, alert) in
                DispatchQueue.main.async {
                    if alert.isSuccess {
                        self.paymentTypes = any as? [PaymentTypesCodable] ?? []
                        self.isSelectedPayment = []
                        for i in 0...(self.paymentTypes.count == 0 ? 0 : self.paymentTypes.count - 1) { self.isSelectedPayment.append(i == 0 ? true : false) }
                    }
                    else { alert.show(controller: self) }
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - TableView

extension DetailAssociationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 || section == 3 || section == 5 { return 1 }
        else if section == 2 { return self.association?.types?.count ?? 0 }
        else if section == 4 { return self.paymentTypes.count }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .associationUser), for: indexPath) as? AssociationUserTableViewCell else { return UITableViewCell() }
            let description = "Os valores dos planos exibidos a seguir são referentes a \(self.user?.associationStatusUUID?.count ?? 0 == 0 ? "nova associação, pois em nossa base de dados essa é a primeira vez que você está se associando" : "reassociação, pois em nossa base de dados essa é não a primeira vez que você está se associando")"
            cell.setCell(name: self.user?.completeName, description: description, image: self.images[self.user?.image ?? ""])
            return cell
        }
        
        else if indexPath.section == 1 { return tableView.dequeueReusableCell(withIdentifier: "AssociationSelectedTypeHeader") ?? UITableViewCell() }
            
        else if indexPath.section == 2 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .simple), for: indexPath) as? SimpleTableViewCell else { return UITableViewCell() }
            let item = self.association?.types?[indexPath.row]
            let description = "\(self.user?.associationStatusUUID?.count ?? 0 == 0 ? item?.values?.first?.value ?? "" : item?.values?.last?.value ?? "")"
            cell.setCell(title: item?.title?.uppercased(), description: description)
            cell.accessoryType = self.isSelectedType[indexPath.row] ? .checkmark : .detailButton
            return cell
        }
        
        else if indexPath.section == 3 { return tableView.dequeueReusableCell(withIdentifier: "AssociationSelectedPaymentHeader") ?? UITableViewCell() }
        
        else if indexPath.section == 4 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .simple), for: indexPath) as? SimpleTableViewCell else { return UITableViewCell() }
            let item = self.paymentTypes[indexPath.row]
            cell.setCell(title: item.name?.uppercased(), description: item.observation?.replacingOccurrences(of: "\\n", with: "\n"))
            cell.accessoryType = self.isSelectedPayment[indexPath.row] ? .checkmark : .none
            return cell
        }
        
        else if indexPath.section == 5 { return tableView.dequeueReusableCell(withIdentifier: "AssociationFinished") ?? UITableViewCell() }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let item = self.association?.types?[indexPath.row]
        var message = ""
        
        item?.benefits?.forEach({ message = message + "• \($0)\n" })
        
        Alert(isSuccess: true, title: item?.title, message: message, style: .alert).show(controller: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            
            for i in 0...(self.association?.types?.count ?? 0 == 0 ? 0 : (self.association?.types?.count ?? 0) - 1) { self.isSelectedType[i] = false }
            self.isSelectedType[indexPath.row] = true
            self.tableView.reloadData()
        }
        
        else if indexPath.section == 4 {
            
            for i in 0...(self.paymentTypes.count == 0 ? 0 : self.paymentTypes.count - 1) { self.isSelectedPayment[i] = false }
            self.isSelectedPayment[indexPath.row] = true
            self.tableView.reloadData()
        }
        
        else if indexPath.section == 5 {
            
            let selectedAssociation = self.association?.types?[self.isSelectedType.firstIndex(of: true) ?? 0]
            let selectedPayment = self.paymentTypes[self.isSelectedPayment.firstIndex(of: true) ?? 0]
            let userPath = Download.getPath(databaseKey: .users).child(Auth.auth().currentUser?.uid ?? "")
            
            userPath.child("associationTypeUUID").setValue(selectedAssociation?.uuid ?? "") { (error, _) in
                
                if error == nil {
                    
                    userPath.child("paymentTypeUUID").setValue(selectedPayment.uuid ?? "") { (error, _) in
                        
                        if error == nil {
                            
                            userPath.child("paymentStatusUUID").setValue("d55b340c-8584-4d22-b16c-ae72fd0607c0") { (error, _) in
                                
                                if error == nil {
                                    
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    guard let controller = storyboard.instantiateViewController(withIdentifier: "StatusAssociationViewController") as? StatusAssociationViewController else { return }
                                    controller.userUID = Auth.auth().currentUser?.uid ?? ""
                                    self.navigationController?.pushViewController(controller, animated: true)
                                }
                            }
                        }
                        
                        else { Alert(isSuccess: false, title: "Erro ao Solicitar Associação", message: "Não foi possível adicionar o tipo de pagamento selecionado", style: .alert).show(controller: self) }
                    }
                }
                
                else { Alert(isSuccess: false, title: "Erro ao Solicitar Associação", message: "Não foi possível adicionar o plano selecionado", style: .alert).show(controller: self) }
            }
        }
    }
}
