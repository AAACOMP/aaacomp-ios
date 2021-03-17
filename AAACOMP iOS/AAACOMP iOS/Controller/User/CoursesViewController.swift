//
//  CoursesViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 18/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import Firebase

class CoursesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var datasource: UITableViewDataSource!
    var delegate: UITableViewDelegate!
    var isSignUpPage: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser == nil && isSignUpPage { self.navigationController?.popViewController(animated: true) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self.delegate
        self.tableView.dataSource = self.datasource
    }
}
