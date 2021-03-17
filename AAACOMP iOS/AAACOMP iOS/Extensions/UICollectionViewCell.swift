//
//  UICollectionViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 31/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    
    func animateOnClick(completion: @escaping (Bool) -> ()) {
        
        self.layer.transform = CATransform3DMakeScale(0.95, 0.95, 1)
        
        UIView.animate(withDuration: 0.3, animations: { self.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1) },completion: { finished in
            
            UIView.animate(withDuration: 0.1, animations: { self.layer.transform = CATransform3DMakeScale(1, 1, 1) }, completion: { finished in
                
                completion(finished)
            })
        })
    }
}
