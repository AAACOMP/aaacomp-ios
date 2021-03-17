//
//  WalletViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 13/06/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import Firebase

class WalletViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: UserCodable?
    var association: AssociationCodable?
    var associationStatus: [AssociationStatusCodable] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser == nil { self.navigationController?.popViewController(animated: true) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
}

// MARK: - Table View

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .wallet), for: indexPath) as? WalletTableViewCell else { return UITableViewCell() }
        cell.setCell(user: self.user, associationStatus: self.associationStatus, association: self.association, controller: self)
        cell.userImageView.kf.setImage(with: URL(string: self.user?.image ?? ""))
        return cell
    }
}
