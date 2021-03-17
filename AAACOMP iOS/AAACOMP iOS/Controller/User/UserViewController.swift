//
//  UserViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 13/06/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class UserViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var auth: Auth!
    private var user: UserCodable?
    private var associationStatus: [AssociationStatusCodable] = []
    private var association: AssociationCodable?
    private var paymentTypes: [PaymentTypesCodable] = []
    private var paymentStatus: [PaymentStatusCodable] = []
    private var userOptions: [UserOption] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.auth = Auth.auth()
        
        if (self.auth.currentUser != nil) { self.loadData(uid: self.auth.currentUser?.uid ?? "") }
        self.tableView.reloadData()
    }
    
    func loadData(uid: String) {
        
        self.tableView.reloadData()
        
        Download.observeUser(uid: uid) { (user, alert) in
            
            DispatchQueue.main.async {
                
                if alert.isSuccess { self.user = user }
                else { alert.show(controller: self) }
                
                self.tableView.reloadData()
                
                Download.observeValues(databaseKey: .associationStatus) { (any, alert) in
                    
                    DispatchQueue.main.async {
                        
                        if alert.isSuccess { self.associationStatus = any as? [AssociationStatusCodable] ?? [] }
                        else { alert.show(controller: self) }
                        
                        self.tableView.reloadData()
                        
                        Download.observeValues(databaseKey: .association) { (any, alert) in
                            
                            DispatchQueue.main.async {
                                
                                if alert.isSuccess { self.association = any as? AssociationCodable }
                                else { alert.show(controller: self) }
                                
                                self.tableView.reloadData()
                                
                                Download.observeValues(databaseKey: .paymentTypes) { (any, alert) in
                                    
                                    DispatchQueue.main.async {
                                        
                                        if alert.isSuccess { self.paymentTypes = any as? [PaymentTypesCodable] ?? [] }
                                        else { alert.show(controller: self) }
                                        
                                        Download.observeValues(databaseKey: .paymentStatus) { (any, alert) in
                                            
                                            if alert.isSuccess { self.paymentStatus = any as? [PaymentStatusCodable] ?? [] }
                                            else { alert.show(controller: self) }
                                            
                                            self.userOptions = UserOption.buildUserOptions(user: self.user, associationStatus: self.associationStatus, association: self.association, paymentTypes: self.paymentTypes, paymentStatus: self.paymentStatus)
                                            
                                            self.tableView.reloadData()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - TableView

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.title = self.auth.currentUser == nil ? "Login" : "Usuário"
        return self.auth.currentUser == nil ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.auth.currentUser == nil) || (self.auth.currentUser != nil && section == 0) { return 1 }
        else if (self.auth.currentUser != nil && section == 1) { return self.userOptions.count }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.auth.currentUser == nil {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .signIn), for: indexPath) as? SignInTableViewCell else { return UITableViewCell() }
            cell.setCell(controller: self, auth: self.auth)
            return cell
        }
            
        else {
            
            if indexPath.section == 0 {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .user), for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
                cell.setCell(user: self.user, associationStatus: self.associationStatus, association: self.association, auth: self.auth, controller: self)
                cell.profileImageView.kf.setImage(with: URL(string: self.user?.image ?? ""))
                return cell
            }
            
            else {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .userOption), for: indexPath) as? UserOptionTableViewCell else { return UITableViewCell() }
                cell.setCell(userOption: self.userOptions[indexPath.row])
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            let item = self.userOptions[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if item.title == "Avisos" {
                guard let controller = storyboard.instantiateViewController(withIdentifier: "WarningViewController") as? WarningViewController else { return }
                controller.user = self.user
                tableView.deselectRow(at: indexPath, animated: true)
                self.navigationController?.pushViewController(controller, animated: true)
            }
                
            else if item.title == "Realizar Associação" {
                
                guard let controller = storyboard.instantiateViewController(withIdentifier: "AssociationViewController") as? AssociationViewController else { return }
                tableView.deselectRow(at: indexPath, animated: true)
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
            else if item.title == "Carteirinha" {
                guard let controller = storyboard.instantiateViewController(withIdentifier: "WalletViewController") as? WalletViewController else { return }
                controller.user = self.user
                controller.association = self.association
                controller.associationStatus = self.associationStatus
                tableView.deselectRow(at: indexPath, animated: true)
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
            else if item.title == "Administração" {
                guard let controller = storyboard.instantiateViewController(withIdentifier: "AdministrationViewController") as? AdministrationViewController else { return }
                tableView.deselectRow(at: indexPath, animated: true)
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
            else if item.title == "Status da Associação" {
                guard let controller = storyboard.instantiateViewController(withIdentifier: "StatusAssociationViewController") as? StatusAssociationViewController else { return }
                controller.userUID = Auth.auth().currentUser?.uid ?? ""
                tableView.deselectRow(at: indexPath, animated: true)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}

// MARK: - Options

extension UserViewController {
    
    struct UserOption {
        
        let title: String?
        let subtitle: String?
        let tag: String?
        let tagColor: UIColor?
        let obs: String?
        let image: UIImage?
        let imageColor: UIColor?
        let hasMore: Bool
        
        static func buildUserOptions(user: UserCodable?, associationStatus: [AssociationStatusCodable], association: AssociationCodable?, paymentTypes: [PaymentTypesCodable], paymentStatus: [PaymentStatusCodable]) -> [UserOption] {
            
            var userOptions: [UserOption] = []
            let validate = associationStatus.filter({$0.isValidate == true}).first(where: {user?.associationStatusUUID?.contains($0.uuid ?? "") ?? false})
            let associationType = association?.types?.first(where: {$0.uuid == user?.associationTypeUUID})
            let statusPayment = paymentStatus.first(where: {$0.uuid == user?.paymentStatusUUID})
            let typePayment = paymentTypes.first(where: {$0.uuid == user?.paymentTypeUUID})
            
            let validates = associationStatus.filter({ $0.isValidate == true })
            let hasValidate = user?.associationStatusUUID?.filter({ (statusUUID) -> Bool in
                return validates.contains(where: { $0.uuid == statusUUID })
            })
            
            print(hasValidate, validates)
            
            userOptions.append(UserOption(title: "Status da Associação", subtitle: "Plano: \(associationType == nil ? "Nenhum plano selecionado" : associationType?.title ?? "")\nForma de Pagamento: \(typePayment?.name ?? "")", tag: statusPayment?.name, tagColor: statusPayment?.uuid == "d55b340c-8584-4d22-b16c-ae72fd0607c0" ? .systemOrange : statusPayment?.uuid == "4b22c3aa-1fca-4b26-b1e6-8f6086e61030" ? .systemGreen : statusPayment?.uuid == "24d21b70-1856-4e8e-a576-2b335f2d0112" ? .systemRed : .lightGray, obs: validate?.validate, image: #imageLiteral(resourceName: "solar-system"), imageColor: .systemPink, hasMore: true))
            userOptions.append(UserOption(title: "Avisos", subtitle: "Fique por dentro de tudo o que está acontecendo", tag: nil, tagColor: nil, obs: nil, image: #imageLiteral(resourceName: "bells"), imageColor: .systemOrange, hasMore: true))
            
            if association?.isOpen == true && hasValidate?.isEmpty != false && validates.isEmpty == false { userOptions.append(UserOption(title: "Realizar Associação", subtitle: "Mais um ano se iniciando e nós já preparamos tudinho para para você", tag: "Com \(association?.types?.count ?? 0) opções de plano", tagColor: .systemPurple, obs: nil, image: #imageLiteral(resourceName: "id-card"), imageColor: .systemPurple, hasMore: true)) }
            
            if user?.credits ?? -1 >= 0 { userOptions.append(UserOption(title: "Programa de Pontos", subtitle: "Você possui \(user?.credits ?? 0) pontos", tag: "Exclusivo", tagColor: nil, obs: nil, image: #imageLiteral(resourceName: "credit-card-front"), imageColor: .systemGreen, hasMore: false)) }
            
            if validate != nil { userOptions.append(UserOption(title: "Carteirinha", subtitle: "Acesse sua carteirinha digital e faça uso dos benefícios", tag: "Válida até \(validate?.validate ?? "")", tagColor: nil, obs: nil, image: #imageLiteral(resourceName: "id-card"), imageColor: .systemPurple, hasMore: true)) }
            
            if user?.isAdm == true { userOptions.append(UserOption(title: "Administração", subtitle: "Gerencie todos os usuários e seus status de associação", tag: "Quem manda é você", tagColor: .systemTeal, obs: nil, image: #imageLiteral(resourceName: "crown"), imageColor: .systemTeal, hasMore: true)) }
            
            return userOptions
        }
    }
}
