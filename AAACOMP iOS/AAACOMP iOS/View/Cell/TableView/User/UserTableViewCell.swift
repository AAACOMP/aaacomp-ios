//
//  UserTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 13/06/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import Firebase

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var associationTypeLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    private var controller: UserViewController!
    private var auth: Auth!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.signOutButton.addTarget(self, action: #selector(self.signOutButtonAction), for: .touchUpInside)
        self.editButton.addTarget(self, action: #selector(self.editButtonAction), for: .touchUpInside)
    }
    
    func setCell(user: UserCodable?, associationStatus: [AssociationStatusCodable], association: AssociationCodable?, auth: Auth, controller: UserViewController) {
        
        self.auth = auth
        self.controller = controller
        
        self.nameLabel.text = user?.completeName
        self.courseLabel.text = user?.course?.uppercased()
        
        let validates = associationStatus.filter({$0.isValidate == true}).first(where: {user?.associationStatusUUID?.contains($0.uuid ?? "") ?? false})
        let associationType = association?.types?.first(where: {$0.uuid == user?.associationTypeUUID})
        
        self.associationTypeLabel.text = (validates == nil ? "Não Associado" : associationType?.title ?? "").uppercased()
    }
    
    @objc private func signOutButtonAction() {
        
        do {
            try self.auth.signOut()
            self.controller.tableView.reloadData()
        }
        catch {
            Alert(isSuccess: false, title: "Erro ao Sair", message: "Não foi possível efetuar o logout", style: .alert).show(controller: self.controller)
        }
    }
    
    @objc private func editButtonAction() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "DetailUserViewController") as? DetailUserViewController else { return }
        self.controller.navigationController?.pushViewController(controller, animated: true)
    }
}
