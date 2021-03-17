//
//  UIView.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 13/06/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableView: UIView { }

@IBDesignable
class DesignableButton: UIButton { }

@IBDesignable
class DesignableLabel: UILabel { }

extension UIView {
    
    // MARK: - DRAWS
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    // MARK: - COLORS
    
    @IBInspectable
    var borderColor: UIColor? {
        
        get {
            if let color = layer.borderColor { return UIColor(cgColor: color) }
            return nil
        }
        
        set {
            if let color = newValue { layer.borderColor = color.cgColor }
            else { layer.borderColor = nil }
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        
        get {
            if let color = layer.shadowColor { return UIColor(cgColor: color) }
            return nil
        }
        
        set {
            if let color = newValue { layer.shadowColor = color.cgColor }
            else { layer.shadowColor = nil }
        }
    }
}

// MARK: - Functions

extension UIView {
    
    enum VisibleMode {
        
        case appear
        case disappear
    }
    
    func visibleMode(mode: VisibleMode, _ withDuration: TimeInterval) {
        
        switch mode {
        
        case .appear: UIView.animate(withDuration: withDuration, animations: { self.alpha = 1 })
        case .disappear: UIView.animate(withDuration: withDuration, animations: { self.alpha = 0 })
            
        }
    }
    
    func addAction(target: Any?, selector: Selector?) {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: target, action: selector)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func moveAndResizeImage(for height: CGFloat, const: Const) {
        
        let coeff: CGFloat = {
            let delta = height - const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (const.NavBarHeightLargeState - const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()

        let factor = const.ImageSizeForSmallState / const.ImageSizeForLargeState

        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()

        // Value of difference between icons for large and small states
        let sizeDiff = const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = const.ImageBottomMarginForLargeState - const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (const.ImageBottomMarginForSmallState + sizeDiff))))
        }()

        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)

        self.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
}

struct Const {
    
    var ImageSizeForLargeState: CGFloat
    var ImageSizeForSmallState: CGFloat
    let ImageRightMargin: CGFloat = 16
    let ImageBottomMarginForLargeState: CGFloat = 12
    let ImageBottomMarginForSmallState: CGFloat = 6
    let NavBarHeightSmallState: CGFloat = 44
    let NavBarHeightLargeState: CGFloat = 96.5
}
