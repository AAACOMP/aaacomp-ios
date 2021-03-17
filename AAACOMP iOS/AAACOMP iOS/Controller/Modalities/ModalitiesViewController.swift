//
//  ModalitiesViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 29/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class ModalitiesViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var modalities: [ModalitiesCodable] = []
    private var modalitiesFilter: [ModalitiesCodable] = []
    private var responsibles: [ResponsibleCodable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Busque pela modalidade ou responsável"
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        self.definesPresentationContext = true
        
        Download.observeValues(databaseKey: .modalities) { (any, alert) in
            
            DispatchQueue.main.async {
                
                if alert.isSuccess {
                    self.modalities = any as? [ModalitiesCodable] ?? []
                    self.modalitiesFilter = self.modalities
                }
                    
                else { alert.show(controller: self) }
                
                self.tableView.reloadData()
                
                Download.observeValues(databaseKey: .responsible) { (any, alert) in
                    
                    if alert.isSuccess { self.responsibles = any as? [ResponsibleCodable] ?? [] }
                    else { alert.show(controller: self) }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text?.isEmpty == false {
            
            let responsiblesFilter = self.responsibles.filter({
                $0.name?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false
            })
            
            self.modalities = self.modalitiesFilter.filter({ (modality) -> Bool in
                return modality.name?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false || responsiblesFilter.contains(where: { (item) -> Bool in return item.uuid == modality.responsibleUUID })
            })
        }
        
        else { self.modalities = self.modalitiesFilter }
        
        self.tableView.reloadData()
    }
}

// MARK: - TableView

extension ModalitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.separatorStyle = self.modalities.count == 0 ? .none : .singleLine
        return modalities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .modality), for: indexPath) as? ModalitiesTableViewCell else { return UITableViewCell() }
        
        let item = self.modalities[indexPath.row]
        cell.setCell(modality: item, responsible: self.responsibles.filter({$0.uuid == item.responsibleUUID}).first)
        
        if let url = URL(string: item.image ?? "") {
            
            cell.modalityImageView.kf.setImage(with: url, completionHandler: { (image, error, _, _) in
                if image != nil && image != UIImage() && error == nil {
                    cell.activityIndicator.stopAnimating()
                    if cell.isReloaded == false {
                        cell.isReloaded = true
                        self.tableView.reloadData()
                    }
                }
                else {
                    cell.activityIndicator.stopAnimating()
                    if cell.isReloaded == false {
                        cell.isReloaded = true
                        self.tableView.reloadData()
                    }
                }
            })
        }
            
        else {
            cell.activityIndicator.stopAnimating()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let modality = self.modalities[indexPath.row]
        let responsible = self.responsibles.filter({$0.uuid == modality.responsibleUUID}).first
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "DetailModalitiesViewController") as? DetailModalitiesViewController else { return }
        controller.modality = modality
        controller.responsible = responsible
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
