//
//  DirectoresTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 30/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import SafariServices

class DirectoresTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var directors: [DirectorsAboutUsCodable] = []
    private var office: [OfficeCodable] = []
    var controller: HomeViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(directors: [DirectorsAboutUsCodable], office: [OfficeCodable]) {
        
        self.directors = directors
        self.office = office
        self.collectionView.setHorizontalCollectionViewLayout(itemsPerRow: self.collectionView.frame.width / 280, height: self.collectionView.frame.height, minimumInteritemSpacing: 10, minimumLineSpacing: 10, sectionInset: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        self.collectionView.reloadData()
    }
}

// MARK: - CollectionView

extension DirectoresTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return directors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.get(identifier: .defaultCard), for: indexPath) as? DefaultCardCollectionViewCell else { return UICollectionViewCell() }
        let item = self.directors[indexPath.row]
        let office = self.office.filter({$0.uuid == item.officeUUID}).first
        cell.setCell(title: item.name?.lowercased().capitalized, subtitle: "\(office?.title ?? "")\n\(item.usualName ?? "")")
        cell.imageView.kf.setImage(with: URL(string: item.image ?? ""), completionHandler: { (image, error, cacheType, url) in
            if image == nil { cell.activityIndicator.startAnimating() }
            else { cell.activityIndicator.stopAnimating() }
        })
        cell.imageView.backgroundColor = UIColor.hexStringToUIColor(hex: item.color ?? "")
        cell.subtitleLabel.numberOfLines = 4
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = self.directors[indexPath.row]
        guard let url = URL(string: item.facebook ?? "") else { return }
        let controller = SFSafariViewController(url: url)
        self.controller.present(controller, animated: true, completion: nil)
    }
}
