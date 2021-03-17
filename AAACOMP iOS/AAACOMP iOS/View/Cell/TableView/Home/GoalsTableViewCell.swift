//
//  GoalsTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 30/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class GoalsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var goals: [GoalsAboutUsCodable] = []
    weak var controller: UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(goals: [GoalsAboutUsCodable]) {
        
        self.goals = goals
        self.collectionView.setHorizontalCollectionViewLayout(itemsPerRow: self.collectionView.frame.width / 320, height: self.collectionView.frame.height, minimumInteritemSpacing: 10, minimumLineSpacing: 10, sectionInset: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        self.collectionView.reloadData()
    }
}

// MARK: - CollectionView

extension GoalsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.get(identifier: .defaultCard), for: indexPath) as? DefaultCardCollectionViewCell else { return UICollectionViewCell() }
        let item = self.goals[indexPath.row]
        cell.setCell(title: item.title, subtitle: item.description)
        cell.imageView.kf.setImage(with: URL(string: item.image ?? ""), completionHandler: { (image, error, cacheType, url) in
            if image == nil { cell.activityIndicator.startAnimating() }
            else { cell.activityIndicator.stopAnimating() }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = self.goals[indexPath.row]
        Alert(isSuccess: true, title: item.title, message: item.description, style: .actionSheet).show(controller: self.controller)
    }
}
