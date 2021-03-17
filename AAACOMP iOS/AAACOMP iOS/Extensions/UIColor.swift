//
//  UIColor.swift
//  AAACOMPiOS
//
//  Created by Rafael Escaleira on 21/04/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let aaacompPurple = UIColor.hexStringToUIColor(hex: "#6E008A")
    
    public static func randomSystemColor() -> UIColor {
        
        let colors: [UIColor] = [.systemRed, .systemBlue, .systemPink, #colorLiteral(red: 0.3831424117, green: 0.7302771807, blue: 0.2767491341, alpha: 1), .systemOrange, .cyan, .systemPurple]
        let randomIndex = Int(arc4random_uniform(UInt32(colors.count - 1)))
        
        return colors[randomIndex]
    }
    
    public static func hexStringToUIColor (hex: String) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") { cString.remove(at: cString.startIndex) }
        
        if cString.count != 6 { return UIColor.black }

        var rgbValue: UInt64 = 0
        
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
    
    var toHexString: String {
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(format: "%02X%02X%02X", Int(r * 0xff), Int(g * 0xff), Int(b * 0xff))
    }
}
