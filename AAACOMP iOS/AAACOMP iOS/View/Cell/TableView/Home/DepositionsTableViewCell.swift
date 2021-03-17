//
//  DepositionsTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 31/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class DepositionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var depositions: [DepositionsAboutUsCodable] = []
    weak var controller: UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(depositions: [DepositionsAboutUsCodable]) {
        
        self.depositions = depositions
        self.collectionView.setHorizontalCollectionViewLayout(itemsPerRow: self.collectionView.frame.width / 350, height: self.collectionView.frame.height, minimumInteritemSpacing: 10, minimumLineSpacing: 10, sectionInset: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        self.collectionView.reloadData()
    }
}

// MARK: - CollectionView

extension DepositionsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return depositions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.get(identifier: .depositionCollection), for: indexPath) as? DepositionCollectionViewCell else { return UICollectionViewCell() }
        let item = self.depositions[indexPath.row]
        cell.setCell(title: item.name, subtitle: item.typePerson, description: item.description)
        cell.depositionImage.kf.setImage(with: URL(string: item.image ?? ""), completionHandler: { (image, error, cacheType, url) in
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = self.depositions[indexPath.row]
        Alert(isSuccess: true, title: item.name, message: item.description, style: .actionSheet).show(controller: self.controller)
    }
}
