//
//  StartScreenViewController.swift
//  ColorMixerApp
//
//  Created by Alexandr Artemov (Mac Mini) on 12.06.2025.
//

import UIKit

protocol ColorSettingsDelegate: AnyObject {
    func didSelectColor(_ color: UIColor)
}

final class ColorDisplayViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? ColorSettingsViewController else { return }
        
        settingsVC.delegate = self
        settingsVC.previousScreenColor = view.backgroundColor
    }
    
}

// MARK: - ColorViewDelegate
extension ColorDisplayViewController: ColorSettingsDelegate {
    func didSelectColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}
