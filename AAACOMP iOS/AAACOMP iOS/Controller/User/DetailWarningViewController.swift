//
//  DetailWarningViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 14/06/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import Firebase

class DetailWarningViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: UserCodable?
    
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

extension DetailWarningViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .detailWarning), for: indexPath) as? DetailWarningTableViewCell else { return UITableViewCell() }
        cell.setCell(user: self.user, controller: self)
        return cell
    }
}
