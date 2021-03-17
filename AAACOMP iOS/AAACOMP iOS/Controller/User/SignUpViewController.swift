//
//  SignUpViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 13/06/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var courses: [CoursesCodable] = []
    var isSelectedCourses: [Bool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        Download.observeValues(databaseKey: .courses) { (any, alert) in
            DispatchQueue.main.async {
                if alert.isSuccess {
                    self.courses = any as? [CoursesCodable] ?? []
                    self.isSelectedCourses = []
                    for i in 0...(self.courses.count == 0 ? 0 : self.courses.count - 1) { self.isSelectedCourses.append(i == 0 ? true : false) }
                }
                else { alert.show(controller: self) }
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - TableView

extension SignUpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 { return 1 }
        else if tableView.tag == 1 {
            tableView.separatorStyle = self.courses.count == 0 ? .none : .singleLine
            return self.courses.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .signUp), for: indexPath) as? SignUpTableViewCell else { return UITableViewCell() }
            cell.controller = self
            
            if self.courses.count > 0 {
                let course = self.courses[self.isSelectedCourses.firstIndex(of: true) ?? 0].name?.capitalized
                cell.courseTextField.text = course
            }
            
            return cell
        }
        
        else if tableView.tag == 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .simple), for: indexPath) as? SimpleTableViewCell else { return UITableViewCell() }
            let item = self.courses[indexPath.row]
            cell.setCell(title: item.name?.uppercased(), description: "\(item.turno?.capitalized ?? "")\n\(item.centro?.capitalized ?? "")")
            cell.accessoryType = self.isSelectedCourses[indexPath.row] ? .checkmark : .none
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 1 {
            
            for i in 0...(self.courses.count == 0 ? 0 : self.courses.count - 1) { self.isSelectedCourses[i] = false }
            self.isSelectedCourses[indexPath.row] = true
            
            tableView.reloadData()
            self.tableView.reloadData()
        }
    }
}
