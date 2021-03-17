//
//  AdministrationViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 13/06/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class AdministrationViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    private var users: [UserCodable] = []
    private var usersFilter: [UserCodable] = []
    private var paymentStatus: [PaymentStatusCodable] = []
    private var associationStatus: [AssociationStatusCodable] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser == nil { self.navigationController?.popViewController(animated: true) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Busque pelo nome, email ou contato"
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        else { self.tableView.tableHeaderView = searchController.searchBar }
        
        self.definesPresentationContext = true
        
        if Auth.auth().currentUser != nil {
            
            Download.observeValues(databaseKey: .users) { (any, alert) in
                
                DispatchQueue.main.async {
                    
                    if alert.isSuccess {
                        
                        self.usersFilter = any as? [UserCodable] ?? []
                        self.users = self.usersFilter
                        self.updateSearchResults(for: self.searchController)
                    }
                        
                    else { alert.show(controller: self) }
                    
                    self.tableView.reloadData()
                    
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
                        }
                    }
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text?.isEmpty == false {
            self.users = self.usersFilter.filter({
                $0.completeName?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false ||
                $0.email?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false ||
                $0.contact?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false
            })
        }
        
        else { self.users = self.usersFilter }
        
        self.tableView.reloadData()
    }
    
    func buildConfirm(user: UserCodable?) {
    
        let userPath = Download.getPath(databaseKey: .users).child(user?.uuid ?? "")
        
        userPath.child("associationStatusUUID").child("\(user?.associationStatusUUID?.count ?? 0)").setValue(self.associationStatus.last?.uuid ?? "") { (error, _) in
            
            if error == nil {
                
                userPath.child("paymentStatusUUID").setValue("4b22c3aa-1fca-4b26-b1e6-8f6086e61030") { (error, _) in
                    
                    if error == nil {
                        
                        if user?.associationTypeUUID != "3c398b51-739c-4aab-a072-65e3c4cb8e24" && user?.credits ?? -1 == -1 { userPath.child("credits").setValue(0) }
                    }
                    
                    else { Alert(isSuccess: false, title: "Erro ao Confirmar Pagamento", message: "Não foi possível alterar o status de pagamento", style: .alert).show(controller: self) }
                }
            }
            
            else { Alert(isSuccess: false, title: "Erro ao Confirmar Pagamento", message: "Não foi possível alterar o status de associação", style: .alert).show(controller: self) }
        }
    }
    
    func buildDisconfirm(user: UserCodable?) {
        
        let userPath = Download.getPath(databaseKey: .users).child(user?.uuid ?? "")
        
        userPath.child("associationStatusUUID").child("\(user?.associationStatusUUID?.count ?? 0 == 0 ? 0 : (user?.associationStatusUUID?.count ?? 0) - 1)").removeValue { (error, _) in
            
            if error == nil {
                
                userPath.child("paymentStatusUUID").setValue("d55b340c-8584-4d22-b16c-ae72fd0607c0") { (error, _) in
                    
                    if error == nil {
                        
                        if user?.credits ?? -1 == 0 { userPath.child("credits").removeValue() }
                    }
                    
                    else { Alert(isSuccess: false, title: "Erro ao Desconfirmar Pagamento", message: "Não foi possível alterar o status de pagamento", style: .alert).show(controller: self) }
                }
            }
            
            else { Alert(isSuccess: false, title: "Erro ao Desconfirmar Pagamento", message: "Não foi possível remover o status de associação", style: .alert).show(controller: self) }
        }
    }
    
    func buildChangeCredits(user: UserCodable?) {
        
        let alert = UIAlertController(title: "Alterar Pontuação", message: "Abaixo está a pontuação de \(user?.completeName ?? "").Informa o novo valor: ", preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Informe a nova pontução"
            textfield.text = "\(user?.credits ?? 0)"
            textfield.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "Alterar", style: .default, handler: { (_) in
            if alert.textFields?[0].text?.isEmpty == false {
                guard let credits = Int((alert.textFields?[0].text)!) else {
                    Alert(isSuccess: false, title: "Erro ao Alterar Pontuação", message: "Para alterar a pontuação é necessário informar um valor válido", style: .alert).show(controller: self)
                    return
                }
                
                Download.getPath(databaseKey: .users).child(user?.uuid ?? "").child("credits").setValue(credits) { (error, _)  in
                    if error != nil {
                        Alert(isSuccess: false, title: "Erro ao Alterar Pontuação", message: "Para alterar a pontuação é necessário informar um valor válido", style: .alert).show(controller: self)
                    }
                }
            }
            else { Alert(isSuccess: false, title: "Erro ao Alterar Pontuação", message: "Para alterar a pontuação é necessário informar um valor válido", style: .alert).show(controller: self) }
        }))
        alert.addAction(UIAlertAction(title: "Voltar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - TableView

extension AdministrationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.separatorStyle = self.users.count == 0 ? .none : .singleLine
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var actions: [UITableViewRowAction] = []

        let item = self.users[indexPath.row]
        
        if item.paymentStatusUUID == "d55b340c-8584-4d22-b16c-ae72fd0607c0" {
            let action = UITableViewRowAction(style: .default, title: "Confirmar Pagamento") { (_, indexPath) in
                self.buildConfirm(user: item)
            }
            action.backgroundColor = .systemTeal
            actions.append(action)
        }

        if item.credits ?? -1 >= 0 && item.associationTypeUUID != "3c398b51-739c-4aab-a072-65e3c4cb8e24" {
            let action = UITableViewRowAction(style: .default, title: "Alterar Pontuação") { (_, indexPath) in
                self.buildChangeCredits(user: item)
            }
            action.backgroundColor = .systemGreen
            actions.append(action)
        }
        
        if item.paymentStatusUUID == "4b22c3aa-1fca-4b26-b1e6-8f6086e61030" {
            let action = UITableViewRowAction(style: .default, title: "Desconfirmar Pagamento") { (_, indexPath) in
                self.buildDisconfirm(user: item)
            }
            action.backgroundColor = .systemRed
            actions.append(action)
        }
        
        return actions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .administration), for: indexPath) as? AdministrationTableViewCell else { return UITableViewCell() }
        let item = self.users[indexPath.row]
        cell.setCell(user: item, paymentStatus: self.paymentStatus)
        cell.userImage.kf.setImage(with: URL(string: item.image ?? ""), placeholder: #imageLiteral(resourceName: "user-circle"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.users[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "DetailAdministrationViewController") as? DetailAdministrationViewController else { return }
        controller.userUUID = item.uuid ?? ""
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
