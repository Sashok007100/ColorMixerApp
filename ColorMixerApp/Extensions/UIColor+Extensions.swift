//
//  UIColor+Extensions.swift
//  ColorMixerApp
//
//  Created by Alexandr Artemov (Mac Mini) on 13.06.2025.
//

import UIKit

extension UIColor {
    func getColors() -> (red: CGFloat, green: CGFloat, blue: CGFloat)? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        if self.getRed(&red, green: &green, blue: &blue, alpha: nil) {
            return (red, green, blue)
        } else {
            return nil
        }
    }
}
