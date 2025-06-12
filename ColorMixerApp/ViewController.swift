//
//  ViewController.swift
//  ColorMixerApp
//
//  Created by Alexandr Artemov (Mac Mini) on 30.05.2025.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var colorView: UIView!

    @IBOutlet var redValueLabel: UILabel!
    @IBOutlet var greenValueLabel: UILabel!
    @IBOutlet var blueValueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    // MARK: - Public Properties
    var previousScreenColor: UIColor!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 20
        
        setupLabels()
        setColor()
    }

    // MARK: - IB Actions
    @IBAction func sliderAction(_ sender: UISlider) {
        setColor()
        
        switch sender {
        case redSlider:
            redValueLabel.text = formattedValue(from: redSlider)
        case greenSlider:
            greenValueLabel.text = formattedValue(from: greenSlider)
        default:
            blueValueLabel.text = formattedValue(from: blueSlider)
        }
    }
    
    // MARK: - Private Methods
    private func setupLabels() {
        redValueLabel.text = formattedValue(from: redSlider)
        greenValueLabel.text = formattedValue(from: greenSlider)
        blueValueLabel.text = formattedValue(from: blueSlider)
    }
    
    private func setColor() {
        colorView.backgroundColor = UIColor(
            red: redSlider.value.cgFloat(),
            green: greenSlider.value.cgFloat(),
            blue: blueSlider.value.cgFloat(),
            alpha: 1
        )
    }
    
    private func formattedValue(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
}

extension Float {
    func cgFloat() -> CGFloat {
        CGFloat(self)
    }
}

