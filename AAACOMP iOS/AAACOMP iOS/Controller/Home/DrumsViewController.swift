//
//  DrumsViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 21/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import SafariServices

class DrumsViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var drums: [DrumsCodable] = []
    private var drumsFilter: [DrumsCodable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Busque por algo na lunática"
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        else { self.tableView.tableHeaderView = self.searchController.searchBar }
        
        self.definesPresentationContext = true
        
        Download.observeValues(databaseKey: .drums) { (any, alert) in
            DispatchQueue.main.async {
                if alert.isSuccess {
                    self.drums = any as? [DrumsCodable] ?? []
                    self.drumsFilter = self.drums
                }
                else { alert.show(controller: self) }
                self.tableView.reloadData()
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text?.isEmpty == false {
            
            self.drums = self.drumsFilter.filter({
                $0.title?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false ||
                $0.description?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false ||
                self.containsPlayers(players: $0.players ?? [], searchText: searchController.searchBar.text!.lowercased())
            })
        }
        
        else { self.drums = self.drumsFilter }
        
        self.tableView.reloadData()
    }
    
    func containsPlayers(players: [String], searchText: String) -> Bool {
        
        var hasPlayer = false
        players.forEach({ if $0.lowercased().contains(searchText) == true { hasPlayer = true } })
        return hasPlayer
    }
}

//MARK: - Table View

extension DrumsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.separatorStyle = self.drums.count == 0 ? .none : .singleLine
        return self.drums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .esports), for: indexPath) as? ESportsTableViewCell else { return UITableViewCell() }
        let item = self.drums[indexPath.row]
        var players = ""
        item.players?.forEach({ i in players = players + "• \(i)\n" })
        cell.accessoryType = item.link == nil ? .none : .disclosureIndicator
        cell.selectionStyle = item.link == nil ? .none : .default
        cell.setCell(title: item.title?.replacingOccurrences(of: "\\n", with: "\n"), description: item.description?.replacingOccurrences(of: "\\n", with: "\n"), players: players.replacingOccurrences(of: "\\n", with: "\n"))
        
        if let url = URL(string: item.image ?? "") {
            
            cell.esportImageView.kf.setImage(with: url, completionHandler: { (image, error, _, _) in
                if image != nil && image != UIImage() && error == nil {
                    cell.heightConstraint.constant = image?.getScaleHeight(width: cell.esportImageView.frame.width) ?? 0
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
        
        let item = self.drums[indexPath.row]
        guard let url = URL(string: item.link ?? "") else { return }
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true) {
            self.tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}
