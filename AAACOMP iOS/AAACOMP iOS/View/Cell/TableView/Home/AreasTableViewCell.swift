//
//  AreasTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 30/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import SafariServices

class AreasTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var areas: [AreasAboutUsCodable] = []
    var controller: HomeViewController!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(areas: [AreasAboutUsCodable]) {
        
        self.areas = areas
        self.collectionView.setHorizontalCollectionViewLayout(itemsPerRow: self.collectionView.frame.width / 320, height: self.collectionView.frame.height, minimumInteritemSpacing: 10, minimumLineSpacing: 10, sectionInset: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        self.collectionView.reloadData()
    }
}

// MARK: - CollectionView

extension AreasTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return areas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.get(identifier: .defaultCard), for: indexPath) as? DefaultCardCollectionViewCell else { return UICollectionViewCell() }
        let item = self.areas[indexPath.row]
        cell.setCell(title: item.titleArea, subtitle: item.description)
        cell.imageView.kf.setImage(with: URL(string: item.image ?? ""), completionHandler: { (image, error, cacheType, url) in
            if image == nil { cell.activityIndicator.startAnimating() }
            else { cell.activityIndicator.stopAnimating() }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? DefaultCardCollectionViewCell else { return }
        
        if indexPath.item == 0 {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "DrumsViewController") as? DrumsViewController else { return }
            self.controller.navigationController?.pushViewController(controller, animated: true)
        }
        
        else if indexPath.item == 1 {
            
            guard let url = URL(string: "https://www.facebook.com/aaacomp.ufms/photos/?ref=page_internal") else { return }
            let controller = SFSafariViewController(url: url)
            self.controller.present(controller, animated: true, completion: nil)
        }
        
        else if indexPath.item == 2 {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "PartnersViewController") as? PartnersViewController else { return }
            self.controller.navigationController?.pushViewController(controller, animated: true)
        }
        
        else if indexPath.item == 3 {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "AssociationViewController") as? AssociationViewController else { return }
            controller.bannerImage = cell.imageView.image
            self.controller.navigationController?.pushViewController(controller, animated: true)
        }
        
        else if indexPath.item == 4 {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "ESportsViewController") as? ESportsViewController else { return }
            self.controller.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
