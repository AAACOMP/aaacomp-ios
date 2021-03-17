//
//  UIImageView.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 30/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func resize() -> CGFloat {
        
        let ratio = (self.image?.size.width ?? 1) / (self.image?.size.height ?? 1)
        let newHeight = self.frame.width / ratio
        
        return newHeight
    }
    
    func isEqualTo(image: UIImage) -> Bool {
        guard let data1 = self.image?.jpegData(compressionQuality: 0.5) as NSData? else { return false }
        guard let data2 = image.jpegData(compressionQuality: 0.5) as NSData? else { return false }
        return data1.isEqual(data2)
    }
}

extension UIImage {
    
    func getScaleHeight(width: CGFloat) -> CGFloat {
        
        let ratio = (self.size.width ?? 1) / (self.size.height ?? 1)
        let newHeight = width / ratio
        
        return newHeight
    }
}

