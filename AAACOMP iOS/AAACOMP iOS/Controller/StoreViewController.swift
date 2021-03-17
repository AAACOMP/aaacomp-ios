//
//  StoreViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 30/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import SafariServices
import Kingfisher

class StoreViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var store: [StoreCodable] = []
    private var storeFilter: [StoreCodable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Busque pelo produto"
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        else { self.tableView.tableHeaderView = self.searchController.searchBar }
        
        self.definesPresentationContext = true
        
        Download.observeValues(databaseKey: .store) { (any, alert) in
            
            DispatchQueue.main.async {
                
                if alert.isSuccess {
                    self.store = any as? [StoreCodable] ?? []
                    self.storeFilter = self.store
                }
                else { alert.show(controller: self) }
                
                self.tableView.reloadData()
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text?.isEmpty == false {
            
            self.store = self.storeFilter.filter({
                $0.title?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false ||
                $0.description?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false
            })
        }
        
        else { self.store = self.storeFilter }
        
        self.tableView.reloadData()
    }
}

// MARK: - TableView

extension StoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.separatorStyle = self.store.count == 0 ? .none : .singleLine
        return self.store.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .store), for: indexPath) as? StoreTableViewCell else { return UITableViewCell() }
        
        let item = self.store[indexPath.row]
        
        cell.accessoryType = item.isOpen == true ? .disclosureIndicator : .none
        cell.selectionStyle = item.isOpen == true ? .default : .none
        
        cell.setCell(products: item)
        
        if let url = URL(string: item.image ?? "") { cell.storeImageView.kf.setImage(with: url) }
        else { cell.storeImageView.image = nil }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.store[indexPath.row]
        
        if item.isOpen != true { return }
        
        guard let url = URL(string: item.forms ?? "") else { return }
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true, completion: { tableView.deselectRow(at: indexPath, animated: true) })
    }
}
