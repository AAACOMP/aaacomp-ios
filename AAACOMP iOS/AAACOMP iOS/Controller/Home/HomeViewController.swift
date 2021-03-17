//
//  HomeViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 30/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import Firebase
import SafariServices

class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var aboutUs: AboutUsCodable?
    private var office: [OfficeCodable] = []
    var imageView = UIImageView(image: #imageLiteral(resourceName: "user-circle"))
    let const = Const(ImageSizeForLargeState: 40, ImageSizeForSmallState: 30)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = const.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        imageView.tintColor = .systemBlue
        imageView.addAction(target: self, selector: #selector(self.pushUser))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
        
        Download.observeValues(databaseKey: .aboutUs) { (any, alert) in
            DispatchQueue.main.async {
                if alert.isSuccess { self.aboutUs = any as? AboutUsCodable }
                else { alert.show(controller: self) }
                self.tableView.reloadData()
            }
        }
        
        Download.observeValues(databaseKey: .office) { (codable, alert) in
            DispatchQueue.main.async {
                if alert.isSuccess { self.office = codable as? [OfficeCodable] ?? [] }
                else { alert.show(controller: self) }
                self.tableView.reloadData()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        self.imageView.moveAndResizeImage(for: height, const: self.const)
    }
    
    @objc func pushUser() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "UserViewController") as? UserViewController else { return }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageView.visibleMode(mode: .disappear, 0.2)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageView.visibleMode(mode: .appear, 0.2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let auth = Auth.auth()
        
        if auth.currentUser != nil {
            
            Download.observeUser(uid: auth.currentUser?.uid ?? "") { (user, alert) in
                
                DispatchQueue.main.async {
                    
                    if !alert.isSuccess { alert.show(controller: self) }
                    self.imageView.kf.setImage(with: URL(string: user?.image ?? ""))
                }
            }
        }
        
        else { self.imageView.image = #imageLiteral(resourceName: "user-circle") }
    }
    
    @objc func showMoreButtonAction(_ sender: UIButton) {
        
        let indexPath = IndexPath(item: sender.tag, section: 2)
        guard let cell = self.tableView.cellForRow(at: indexPath) as? HistoryTableViewCell else { return }
        
        if cell.historyLabel.numberOfLines == 4 {
            cell.historyLabel.numberOfLines = 0
            cell.showMoreButton.setTitle("Mostrar Menos", for: .normal)
        }
        
        else {
            cell.historyLabel.numberOfLines = 4
            cell.showMoreButton.setTitle("Mostrar Mais", for: .normal)
        }
        
        self.tableView.reloadData()
    }
}

// MARK: - Table View

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { return 7 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if section == 0 { count = self.aboutUs?.areas?.count ?? 0 == 0 ? 0 : 1 }
        else if section == 1 { count = self.aboutUs?.goals?.count ?? 0 == 0 ? 0 : 1 }
        else if section == 2 { count = self.aboutUs?.story ?? "" == "" ? 0 : 1 }
        else if section == 3 { count = self.aboutUs?.attributes?.count ?? 0 }
        else if section == 4 { count = self.aboutUs?.directors?.count ?? 0 == 0 ? 0 : 1 }
        else if section == 5 { count = self.aboutUs?.depositions?.count ?? 0 == 0 ? 0 : 1 }
        else if section == 6 { count = self.aboutUs?.contact?.count ?? 0 }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .areas), for: indexPath) as? AreasTableViewCell else { return UITableViewCell() }
            cell.setCell(areas: self.aboutUs?.areas ?? [])
            cell.controller = self
            return cell
        }
        
        else if indexPath.section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .goals), for: indexPath) as? GoalsTableViewCell else { return UITableViewCell() }
            cell.setCell(goals: self.aboutUs?.goals ?? [])
            cell.controller = self
            return cell
        }
            
        else if indexPath.section == 2 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .history), for: indexPath) as? HistoryTableViewCell else { return UITableViewCell() }
            cell.setCell(history: self.aboutUs?.story, tag: indexPath.row)
            cell.showMoreButton.addTarget(self, action: #selector(self.showMoreButtonAction(_:)), for: .touchUpInside)
            return cell
        }
            
        else if indexPath.section == 3 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .attributes), for: indexPath) as? AttributesTableViewCell else { return UITableViewCell() }
            let item = self.aboutUs?.attributes?[indexPath.row]
            
            if indexPath.row % 2 == 0 { cell.setCell(left: item?.title, right: item?.description, hex: item?.color, isTitleLeft: true) }
            else { cell.setCell(left: item?.description, right: item?.title, hex: item?.color, isTitleLeft: false) }
            
            return cell
        }
        
        else if indexPath.section == 4 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .directors), for: indexPath) as? DirectoresTableViewCell else { return UITableViewCell() }
            cell.controller = self
            cell.setCell(directors: self.aboutUs?.directors ?? [], office: self.office)
            return cell
        }
        
        else if indexPath.section == 5 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .deposition), for: indexPath) as? DepositionsTableViewCell else { return UITableViewCell() }
            cell.setCell(depositions: self.aboutUs?.depositions ?? [])
            cell.controller = self
            return cell
        }
        
        else if indexPath.section == 6 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .userOption), for: indexPath) as? UserOptionTableViewCell else { return UITableViewCell() }
            let item = self.aboutUs?.contact?[indexPath.row]
            
            cell.setCell(userOption: UserViewController.UserOption(title: item?.title, subtitle: item?.description?.replacingOccurrences(of: "\\n", with: "\n") ?? (item?.value ?? ""), tag: nil, tagColor: nil, obs: nil, image: nil, imageColor: nil, hasMore: true))
            
            if let url = URL(string: item?.image ?? "") {
                cell.optionImageView.kf.setImage(with: url)
                cell.selectionStyle = .default
            }
                
            cell.selectionStyle = item?.value?.isValidEmail() ?? false ? .none : .default
            cell.accessoryType = item?.value?.isValidEmail() ?? false ? .none : .disclosureIndicator
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 6 {
            
            let item = self.aboutUs?.contact?[indexPath.row]
            if item?.value?.isValidEmail() ?? false { return }
            guard let url = URL(string: item?.value ?? "") else { return }
            let controller = SFSafariViewController(url: url)
            self.present(controller, animated: true, completion: { self.tableView.deselectRow(at: indexPath, animated: true) })
        }
    }
}
