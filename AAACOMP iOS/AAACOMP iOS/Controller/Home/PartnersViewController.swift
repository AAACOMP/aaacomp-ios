//
//  PartnersViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 31/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import SafariServices

class PartnersViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var partners: [PartnersCodable] = []
    private var partnersFilter: [PartnersCodable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Busque pelo parceiro"
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        else { self.tableView.tableHeaderView = self.searchController.searchBar }
        
        self.definesPresentationContext = true

        Download.observeValues(databaseKey: .partners) { (any, alert) in
            DispatchQueue.main.async {
                if alert.isSuccess {
                    self.partners = any as? [PartnersCodable] ?? []
                    self.partnersFilter = self.partners
                }
                else { alert.show(controller: self) }
                self.tableView.reloadData()
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text?.isEmpty == false {
            
            self.partners = self.partnersFilter.filter({
                $0.name?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false ||
                $0.description?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false
            })
        }
        
        else { self.partners = self.partnersFilter }
        
        self.tableView.reloadData()
    }
}

// MARK: - TableView

extension PartnersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.separatorStyle = self.partners.count == 0 ? .none : .singleLine
        return self.partners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .partners), for: indexPath) as? PartnersTableViewCell else { return UITableViewCell() }
        let item = self.partners[indexPath.row]
        cell.selectionStyle = item.url == nil ? .none : .default
        cell.setCell(partner: item)
        
        if let url = URL(string: item.image ?? "") { cell.partnerImageView.kf.setImage(with: url) }
        else { cell.partnerImageView.image = nil }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !(self.partners[indexPath.row].url?.verifyUrl() ?? false) {
            self.tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        guard let url = URL(string: self.partners[indexPath.row].url ?? "") else { return }
        let controller = SFSafariViewController(url: url)
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.present(controller, animated: true, completion: nil)
    }
}
