//
//  DetailAdministrationViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 15/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class DetailAdministrationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userUUID: String = ""
    private var user: UserCodable?
    private var associationStatus: [AssociationStatusCodable] = []
    private var association: AssociationCodable?
    private var paymentTypes: [PaymentTypesCodable] = []
    private var paymentStatus: [PaymentStatusCodable] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser == nil { self.navigationController?.popViewController(animated: true) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        
        if Auth.auth().currentUser != nil { self.loadData(uid: self.userUUID) }
        
    }
    
    func loadData(uid: String) {
        
        self.tableView.reloadData()
        
        Download.observeUser(uid: uid) { (user, alert) in
            
            DispatchQueue.main.async {
                
                if alert.isSuccess {
                    self.user = user
                    self.user?.uuid = self.userUUID
                }
                    
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

    @objc func buildConfirmOrDisconfirm() {
    
        let userPath = Download.getPath(databaseKey: .users).child(user?.uuid ?? "")
        
        if user?.paymentStatusUUID == "4b22c3aa-1fca-4b26-b1e6-8f6086e61030" {
            
            userPath.child("associationStatusUUID").child("\(user?.associationStatusUUID?.count ?? 0 == 0 ? 0 : (user?.associationStatusUUID?.count ?? 0) - 1)").removeValue { (error, _) in
                
                if error == nil {
                    
                    userPath.child("paymentStatusUUID").setValue("d55b340c-8584-4d22-b16c-ae72fd0607c0") { (error, _) in
                        
                        if error == nil {
                            
                            if self.user?.credits ?? -1 == 0 { userPath.child("credits").removeValue() }
                        }
                        
                        else { Alert(isSuccess: false, title: "Erro ao Desconfirmar Pagamento", message: "Não foi possível alterar o status de pagamento", style: .alert).show(controller: self) }
                    }
                }
                
                else { Alert(isSuccess: false, title: "Erro ao Desconfirmar Pagamento", message: "Não foi possível remover o status de associação", style: .alert).show(controller: self) }
            }
        }
        
        else if user?.paymentStatusUUID != "7db8d5ed-ce64-47d0-af4f-f17cdf783f7e" {
            
            userPath.child("associationStatusUUID").child("\(user?.associationStatusUUID?.count ?? 0)").setValue(self.associationStatus.last?.uuid ?? "") { (error, _) in
                
                if error == nil {
                    
                    userPath.child("paymentStatusUUID").setValue("4b22c3aa-1fca-4b26-b1e6-8f6086e61030") { (error, _) in
                        
                        if error == nil {
                            
                            if self.user?.associationTypeUUID != "3c398b51-739c-4aab-a072-65e3c4cb8e24" && self.user?.credits ?? -1 == -1 { userPath.child("credits").setValue(0) }
                        }
                        
                        else { Alert(isSuccess: false, title: "Erro ao Confirmar Pagamento", message: "Não foi possível alterar o status de pagamento", style: .alert).show(controller: self) }
                    }
                }
                
                else { Alert(isSuccess: false, title: "Erro ao Confirmar Pagamento", message: "Não foi possível alterar o status de associação", style: .alert).show(controller: self) }
            }
        }
        
        else {
            Alert(isSuccess: false, title: "Sem Tentativa de Associação", message: "Não é possível confirmar ou desconfirmar o pagamento, pois \(user?.completeName ?? "") não realizou associação", style: .alert).show(controller: self)
        }
    }
    
    @objc func buildChangeCredits() {
        
        if self.user?.credits ?? -1 == -1 || self.user?.associationTypeUUID == "3c398b51-739c-4aab-a072-65e3c4cb8e24" {
            
            let alert = UIAlertController(title: "Alterar Pontuação", message: "Não é possível alterar a pontuação para esse usuário, pois ele não pertence ao plano black ou plano atleta.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        else {
            
            let alert = UIAlertController(title: "Alterar Pontuação", message: "Abaixo está a pontuação de \(user?.completeName ?? "").Informa o novo valor: ", preferredStyle: .alert)
            
            alert.addTextField { (textfield) in
                textfield.placeholder = "Informe a nova pontução"
                textfield.text = "\(self.user?.credits ?? 0)"
                textfield.keyboardType = .numberPad
            }
            
            alert.addAction(UIAlertAction(title: "Alterar", style: .default, handler: { (_) in
                if alert.textFields?[0].text?.isEmpty == false {
                    guard let credits = Int((alert.textFields?[0].text)!) else {
                        Alert(isSuccess: false, title: "Erro ao Alterar Pontuação", message: "Para alterar a pontuação é necessário informar um valor válido", style: .alert).show(controller: self)
                        return
                    }
                    
                    Download.getPath(databaseKey: .users).child(self.user?.uuid ?? "").child("credits").setValue(credits) { (error, _)  in
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
}

// MARK: - TableView

extension DetailAdministrationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .detailAdministration), for: indexPath) as? DetailAdministrationTableViewCell else { return UITableViewCell() }
        
        let validate = associationStatus.filter({$0.isValidate == true}).first(where: {user?.associationStatusUUID?.contains($0.uuid ?? "") ?? false})
        let associationType = association?.types?.first(where: {$0.uuid == user?.associationTypeUUID})
        let statusPayment = paymentStatus.first(where: {$0.uuid == user?.paymentStatusUUID})
        let typePayment = paymentTypes.first(where: {$0.uuid == user?.paymentTypeUUID})
        
        cell.setCell(user: self.user)
        cell.userImage.kf.setImage(with: URL(string: self.user?.image ?? ""), placeholder: #imageLiteral(resourceName: "user-circle"))
        
        cell.paymentButton.addTarget(self, action: #selector(self.buildConfirmOrDisconfirm), for: .touchUpInside)
        cell.creditsButton.addTarget(self, action: #selector(self.buildChangeCredits), for: .touchUpInside)
        
        cell.statusTagLabel.text = statusPayment?.name?.uppercased()
        cell.statusTagLabel.textColor = statusPayment?.uuid == "d55b340c-8584-4d22-b16c-ae72fd0607c0" ? .systemOrange : statusPayment?.uuid == "4b22c3aa-1fca-4b26-b1e6-8f6086e61030" ? .systemGreen : statusPayment?.uuid == "24d21b70-1856-4e8e-a576-2b335f2d0112" ? .systemRed : .lightGray
        cell.statusDescriptionLabel.text = "Plano: \(associationType == nil ? "Nenhum plano selecionado" : associationType?.title ?? "")\nForma de Pagamento: \(typePayment?.name ?? "")"
        cell.statusObsLabel.text = validate?.validate
        
        let associationValue = (self.user?.associationStatusUUID?.count ?? 0 == 0 && statusPayment?.uuid == "7db8d5ed-ce64-47d0-af4f-f17cdf783f7e") ? "" : (self.user?.associationStatusUUID?.count ?? 0 == 0 && statusPayment?.uuid == "d55b340c-8584-4d22-b16c-ae72fd0607c0") ? associationType?.values?.first?.value ?? "" : (self.user?.associationStatusUUID?.count ?? 0 == 1 && statusPayment?.uuid == "d55b340c-8584-4d22-b16c-ae72fd0607c0") ? associationType?.values?.last?.value ?? "" : (self.user?.associationStatusUUID?.count ?? 0 == 1 && statusPayment?.uuid == "4b22c3aa-1fca-4b26-b1e6-8f6086e61030") ? associationType?.values?.first?.value ?? "" : self.user?.associationStatusUUID?.count ?? 0 > 1 ? associationType?.values?.last?.value ?? "" : ""
        
        cell.associationValueLabel.text = associationValue
        cell.associationStatusLabel.text = statusPayment?.name?.uppercased()
        cell.statusView.backgroundColor = statusPayment?.uuid == "d55b340c-8584-4d22-b16c-ae72fd0607c0" ? .systemOrange : statusPayment?.uuid == "4b22c3aa-1fca-4b26-b1e6-8f6086e61030" ? .systemGreen : statusPayment?.uuid == "24d21b70-1856-4e8e-a576-2b335f2d0112" ? .systemRed : .systemGray
        
        return cell
    }
}
