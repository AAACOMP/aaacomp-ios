//
//  WarningViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 13/06/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import SafariServices
import Firebase

class WarningViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pushBarButton: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var warnings: [WarningCodable] = []
    private var warningsFilter: [WarningCodable] = []
    var user: UserCodable?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser == nil { self.navigationController?.popViewController(animated: true) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user?.isAdm != true { self.navigationItem.rightBarButtonItem = nil }
        
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Busque pelo aviso"
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        else { self.tableView.tableHeaderView = searchController.searchBar }
        
        self.definesPresentationContext = true
        
        if Auth.auth().currentUser != nil {
            
            Download.observeWarnings { (warnings, alert) in
                DispatchQueue.main.async {
                    if alert.isSuccess {
                        self.warnings = warnings
                        self.warningsFilter = self.warnings
                        
                        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? WarningTableViewCell
                        cell?.isReloaded = false
                    }
                    else { alert.show(controller: self) }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text?.isEmpty == false {
            self.warnings = self.warningsFilter.filter({
                $0.title?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false ||
                $0.message?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false ||
                $0.tag?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false ||
                $0.date?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false ||
                $0.user?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false
            })
        }
        
        else { self.warnings = self.warningsFilter }
        
        self.tableView.reloadData()
    }
    
    @IBAction func pushDetail() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "DetailWarningViewController") as? DetailWarningViewController else { return }
        controller.user = self.user
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - Table View

extension WarningViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.separatorStyle = self.warnings.count != 0 ? .singleLine : .none
        return self.warnings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .warning), for: indexPath) as? WarningTableViewCell else { return UITableViewCell() }
        let item = self.warnings[indexPath.row]
        
        var strUrl = item.link
        
        if strUrl?.lowercased().hasPrefix("http://") == false && strUrl?.lowercased().hasPrefix("https://") == false {
            strUrl = "http://" + (strUrl ?? "")
        }
        
        if strUrl?.verifyUrl() ?? false { cell.accessoryType = .disclosureIndicator }
        else { cell.accessoryType = .none }
            
        cell.setCell(warning: item)
        
        if let url = URL(string: item.image ?? "") {
            
            cell.warningImageView.kf.setImage(with: url, completionHandler: { (image, error, _, _) in
                if image != nil && image != UIImage() && error == nil {
                    cell.heightConstraint.constant = image?.getScaleHeight(width: cell.warningImageView.frame.width) ?? 0
                    if cell.isReloaded == false {
                        cell.isReloaded = true
                        self.tableView.reloadData()
                    }
                }
                else {
                    cell.heightConstraint.constant = 0
                    if cell.isReloaded == false {
                        cell.isReloaded = true
                        self.tableView.reloadData()
                    }
                }
            })
        }
            
        else {
            cell.heightConstraint.constant = 0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.warnings[indexPath.row]
        var strUrl = item.link
        
        if strUrl?.lowercased().hasPrefix("http://") == false && strUrl?.lowercased().hasPrefix("https://") == false {
            strUrl = "http://" + (strUrl ?? "")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.user?.isAdm == true {
            
            let alert = Alert(isSuccess: true, title: "Deseja Remover o Aviso?", message: "\(item.title ?? "")\n\(item.message ?? "")", style: .alert)
            
            alert.alert.addAction(UIAlertAction(title: "Remover", style: .destructive, handler: { (_) in
                
                if item.image != nil && item.image != "" {
                    
                    Storage.storage().reference().child("warnings").child(item.uuid ?? "").delete { (error) in
                        
                        if error == nil {
                            
                            Database.database().reference().child("warnings").child(item.uuid ?? "").removeValue { (error, _) in
                                
                                if error != nil {
                                    Alert(isSuccess: false, title: "Erro ao remover aviso", message: error?.localizedDescription, style: .alert).show(controller: self)
                                    return
                                }
                            }
                        }
                        
                        else { Alert(isSuccess: false, title: "Erro ao remover aviso", message: error?.localizedDescription, style: .alert).show(controller: self) }
                    }
                }
                
                else {
                    
                    Database.database().reference().child("warnings").child(item.uuid ?? "").removeValue { (error, _) in
                        
                        if error != nil {
                            Alert(isSuccess: false, title: "Erro ao remover aviso", message: error?.localizedDescription, style: .alert).show(controller: self)
                            return
                        }
                    }
                }
            }))
            
            if item.link?.isEmpty == false { alert.alert.addAction(UIAlertAction(title: "Acessar Link", style: .default, handler: { (_) in
                
                guard let url = URL(string: strUrl ?? "") else { return }
                
                let controller = SFSafariViewController(url: url)
                self.present(controller, animated: true, completion: nil)
            })) }
            
            alert.show(controller: self)
        }
        
        else {
            
            guard let url = URL(string: strUrl ?? "") else { return }
            
            let controller = SFSafariViewController(url: url)
            self.present(controller, animated: true, completion: nil)
        }
    }
}
