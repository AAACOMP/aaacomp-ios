//
//  DetailEventsViewController.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 31/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class DetailEventsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var event: EventsCodable?
    var image: UIImage?
    var responsibles: [ResponsibleCodable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - TableView

extension DetailEventsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.separatorStyle = .singleLine
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if section == 0 { count = self.event == nil ? 0 : 1 }
        else if section == 1 { count = (self.event?.moreInfo?.drinks?.count ?? 0) == 0 ? 0 : (self.event?.moreInfo?.drinks?.count ?? 0) + 1 }
        else if section == 2 { count = (self.event?.moreInfo?.attractions?.count ?? 0) == 0 ? 0 : (self.event?.moreInfo?.attractions?.count ?? 0) + 1 }
        else if section == 3 { count = (self.event?.moreInfo?.moreover?.count ?? 0) == 0 ? 0 : (self.event?.moreInfo?.moreover?.count ?? 0) + 1 }
        else if section == 4 { count = (self.event?.moreInfo?.allotments?.count ?? 0) == 0 ? 0 : (self.event?.moreInfo?.allotments?.count ?? 0) + 1 }
        else if section == 5 { count = self.responsibles.count == 0 ? 0 : self.responsibles.count + 1 }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .detailEvents), for: indexPath) as? DetailEventsTableViewCell else { return UITableViewCell() }
            cell.setCell(event: self.event)
            cell.eventImageView.image = self.image
            
            return cell
        }
        
        else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .simple), for: indexPath) as? SimpleTableViewCell else { return UITableViewCell() }
                cell.setCell(title: "BEBIDAS", description: nil)
                return cell
            }
            
            else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .moreDetailEvents), for: indexPath) as? MoreDetailEventsTableViewCellTableViewCell else { return UITableViewCell() }
                let item = self.event?.moreInfo?.drinks?[indexPath.row - 1]
                cell.setCell(userOption: MoreDetailEventsOption(title: item?.name, subtitle: item?.type, tag: nil, tagColor: nil, obs: nil, image: nil, imageColor: .systemPink, hasMore: false))
                cell.loadImage(itemImage: item?.image, emptyImage: #imageLiteral(resourceName: "cocktail"), isEmpty: self.event?.moreInfo?.drinks?.isEmpty, tableView: self.tableView, indexPath: indexPath)
                
                return cell
            }
        }
        
        else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .simple), for: indexPath) as? SimpleTableViewCell else { return UITableViewCell() }
                cell.setCell(title: "ATRAÇÕES", description: nil)
                return cell
            }
            
            else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .moreDetailEvents), for: indexPath) as? MoreDetailEventsTableViewCellTableViewCell else { return UITableViewCell() }
                let item = self.event?.moreInfo?.attractions?[indexPath.row - 1]
                cell.setCell(userOption: MoreDetailEventsOption(title: item?.name, subtitle: item?.description, tag: nil, tagColor: nil, obs: nil, image: nil, imageColor: .systemBlue, hasMore: false))
                cell.loadImage(itemImage: item?.image, emptyImage: #imageLiteral(resourceName: "microphone-alt"), isEmpty: self.event?.moreInfo?.attractions?.isEmpty, tableView: self.tableView, indexPath: indexPath)
                
                return cell
            }
        }
        
        else if indexPath.section == 3 {
            
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .simple), for: indexPath) as? SimpleTableViewCell else { return UITableViewCell() }
                cell.setCell(title: "ALÉM DISSO ...", description: nil)
                return cell
            }
            
            else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .moreDetailEvents), for: indexPath) as? MoreDetailEventsTableViewCellTableViewCell else { return UITableViewCell() }
                let item = self.event?.moreInfo?.moreover?[indexPath.row - 1]
                cell.setCell(userOption: MoreDetailEventsOption(title: item?.title, subtitle: item?.description, tag: nil, tagColor: nil, obs: nil, image: nil, imageColor: .systemOrange, hasMore: false))
                cell.loadImage(itemImage: item?.image, emptyImage: #imageLiteral(resourceName: "speakers"), isEmpty: self.event?.moreInfo?.moreover?.isEmpty, tableView: self.tableView, indexPath: indexPath)
                
                return cell
            }
        }
        
        else if indexPath.section == 4 {
            
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .simple), for: indexPath) as? SimpleTableViewCell else { return UITableViewCell() }
                cell.setCell(title: "LOTES", description: nil)
                return cell
            }
            
            else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .moreDetailEvents), for: indexPath) as? MoreDetailEventsTableViewCellTableViewCell else { return UITableViewCell() }
                let item = self.event?.moreInfo?.allotments?[indexPath.row - 1]
                cell.setCell(userOption: MoreDetailEventsOption(title: item?.title, subtitle: "\(item?.initialDate ?? "") - \(item?.finalDate ?? "")", tag: item?.priceTitle ?? "", tagColor: nil, obs: nil, image: nil, imageColor: .systemGreen, hasMore: false))
                cell.loadImage(itemImage: item?.image, emptyImage: #imageLiteral(resourceName: "ticket"), isEmpty: self.event?.moreInfo?.allotments?.isEmpty, tableView: self.tableView, indexPath: indexPath)
                
                return cell
            }
        }
        
        else if indexPath.section == 5 {
            
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .simple), for: indexPath) as? SimpleTableViewCell else { return UITableViewCell() }
                cell.setCell(title: "VENDEDORES E RESPONSÁVEIS", description: nil)
                return cell
            }
            
            else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.get(identifier: .moreDetailEvents), for: indexPath) as? MoreDetailEventsTableViewCellTableViewCell else { return UITableViewCell() }
                let item = self.responsibles[indexPath.row - 1]
                cell.setCell(userOption: MoreDetailEventsOption(title: item.name, subtitle: "\(item.email ?? "")\n\(item.phone?.applyMask(.phone) ?? "")", tag: nil, tagColor: nil, obs: nil, image: nil, imageColor: .systemTeal, hasMore: self.responsibles.count > 0 ? true : false))
                cell.loadImage(itemImage: item.image, emptyImage: #imageLiteral(resourceName: "user-tie"), isEmpty: self.responsibles.count == 0, tableView: self.tableView, indexPath: indexPath)
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 5 && indexPath.row > 0 && self.responsibles.count > 0 {
            
            let responsible = self.responsibles[indexPath.row - 1]
            tableView.deselectRow(at: indexPath, animated: true)
            guard let whatsappURL = URL(string: "whatsapp://send?phone=55\(responsible.phone?.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "") ?? "")") else { return }
            if UIApplication.shared.canOpenURL(whatsappURL) { UIApplication.shared.openURL(whatsappURL) }
            else {
                Alert(isSuccess: false, title: "Não foi possível abrir uma conversa pelo whastapp", message: "Pode ser que você não tenha o whatsapp instalado ou que o número de contato de \(responsible.name ?? "") esteja errado", style: .alert).show(controller: self)
            }
        }
    }
}

// MARK: - Options

extension DetailEventsViewController {
    
    struct MoreDetailEventsOption {
        
        let title: String?
        let subtitle: String?
        let tag: String?
        let tagColor: UIColor?
        let obs: String?
        let image: UIImage?
        let imageColor: UIColor?
        let hasMore: Bool
    }
}
