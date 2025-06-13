//
//  StartScreenViewController.swift
//  ColorMixerApp
//
//  Created by Alexandr Artemov (Mac Mini) on 12.06.2025.
//

import UIKit

final class StartScreenViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? ColorViewController else { return }
        
        settingsVC.delegate = self
        settingsVC.previousScreenColor = view.backgroundColor
    }
    
}

// MARK: - ColorViewDelegate
extension StartScreenViewController: ColorViewDelegate {
    func didSelectColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}
