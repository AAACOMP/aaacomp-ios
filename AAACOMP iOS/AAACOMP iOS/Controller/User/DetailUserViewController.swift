//
//  DetailUserViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 19/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import Firebase

class DetailUserViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var courses: [CoursesCodable] = []
    var user: UserCodable?
    var isSelectedCourses: [Bool] = []
    var image: UIImage?
    
    private var isNewCourse: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser == nil { self.navigationController?.popViewController(animated: true) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        if Auth.auth().currentUser != nil {
            
            Download.observeUser(uid: Auth.auth().currentUser?.uid ?? "") { (user, alert) in
                DispatchQueue.main.async {
                    if alert.isSuccess { self.user = user }
                    else { alert.show(controller: self) }
                    self.tableView.reloadData()
                    
                    Download.images(urls: [self.user?.image ?? ""]) { (images, alert) in
                        DispatchQueue.main.async {
                            if alert.isSuccess { self.image = images.first?.value }
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            
            Download.observeValues(databaseKey: .courses) { (any, alert) in
                DispatchQueue.main.async {
                    if alert.isSuccess {
                        self.courses = any as? [CoursesCodable] ?? []
                        self.isSelectedCourses = []
                        self.courses.forEach({ _ in self.isSelectedCourses.append(false) })
                        let index = self.courses.firstIndex(where: { $0.name?.lowercased().contains(self.user?.course?.lowercased() ?? "") ?? false }) ?? 0
                        if self.courses.count > 0 { self.isSelectedCourses[index] = true }
                    }
                    else { alert.show(controller: self) }
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - TableView

extension DetailUserViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .detailUser), for: indexPath) as? DetailUserTableViewCell else { return UITableViewCell() }
            cell.controller = self
            cell.user = self.user
            cell.userImage.image = self.image
            
            if self.courses.count > 0 {
                let course = self.courses[self.isSelectedCourses.firstIndex(of: true) ?? 0].name?.uppercased()
                cell.courseTextField.text = self.isNewCourse == false ? self.user?.course?.uppercased() : course
            }
                
            else { cell.courseTextField.text = self.user?.course?.uppercased() }
            
            cell.nameTextField.text = self.user?.completeName?.capitalized
            cell.cpfTextField.text = self.user?.cpf?.applyMask(.cpf)
            cell.rgaTextField.text = self.user?.rga?.applyMask(.rga)
            cell.MDate.selectDate = String.getDate(dateFormat: "dd/MM/yyyy", dateStr: self.user?.birthday ?? "")
            cell.phoneTextField.text = self.user?.contact?.applyMask(.phone)
            
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
            self.isNewCourse = true
            tableView.reloadData()
            self.tableView.reloadData()
        }
    }
}
