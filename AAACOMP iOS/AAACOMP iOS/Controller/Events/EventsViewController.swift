//
//  EventsViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 29/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var events: [EventsCodable] = []
    private var eventsFilter: [EventsCodable] = []
    private var responsibles: [ResponsibleCodable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Busque pelo evento"
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        else { self.tableView.tableHeaderView = self.searchController.searchBar }
        
        self.definesPresentationContext = true
        
        Download.observeValues(databaseKey: .events) { (any, alert) in
            
            DispatchQueue.main.async {
                
                if alert.isSuccess {
                    self.events = (any as? [EventsCodable] ?? []).reversed()
                    self.eventsFilter = self.events
                }
                else { alert.show(controller: self) }
                
                self.tableView.reloadData()
                
                Download.observeValues(databaseKey: .responsible) { (any, alert) in
                    
                    DispatchQueue.main.async {
                        
                        if alert.isSuccess { self.responsibles = any as? [ResponsibleCodable] ?? [] }
                        else { alert.show(controller: self) }
                        
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text?.isEmpty == false {
            
            self.events = self.eventsFilter.filter({
                $0.name?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false ||
                $0.description?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false ||
                $0.date?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false
            })
        }
        
        else { self.events = self.eventsFilter }
        
        self.tableView.reloadData()
    }
}

// MARK: - TableView

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.separatorStyle = self.events.count == 0 ? .none : .singleLine
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .events), for: indexPath) as? EventsTableViewCell else { return UITableViewCell() }
        
        let item = self.events[indexPath.row]
        
        cell.setCell(event: item)
        
        if let url = URL(string: item.image ?? "") { cell.eventImageView.kf.setImage(with: url) }
        else { cell.eventImageView.image = nil }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? EventsTableViewCell else { return }
        let item = self.events[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "DetailEventsViewController") as? DetailEventsViewController else { return }
        controller.event = item
        controller.image = cell.eventImageView.image
        controller.responsibles = self.responsibles
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
