//
//  ColorViewController.swift
//  ColorMixerApp
//
//  Created by Alexandr Artemov (Mac Mini) on 30.05.2025.
//

import UIKit

protocol ColorViewDelegate: AnyObject {
    func didSelectColor(_ color: UIColor)
}

final class ColorViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var colorView: UIView!

    @IBOutlet var redValueLabel: UILabel!
    @IBOutlet var greenValueLabel: UILabel!
    @IBOutlet var blueValueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
    
    // MARK: - Public Properties
    weak var delegate: ColorViewDelegate?
    
    var previousScreenColor: UIColor!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 20
        
        updateColor()
        setupLabels()
        setupTextField()
        setColor()
    }

    // MARK: - IB Actions
    @IBAction func sliderAction(_ sender: UISlider) {
        setColor()
        
        switch sender {
        case redSlider:
            redValueLabel.text = formattedValue(from: redSlider)
            redTextField.text = formattedValue(from: redSlider)
        case greenSlider:
            greenValueLabel.text = formattedValue(from: greenSlider)
            greenTextField.text = formattedValue(from: greenSlider)
        default:
            blueValueLabel.text = formattedValue(from: blueSlider)
            blueTextField.text = formattedValue(from: blueSlider)
        }
    }
    
    @IBAction func doneButtonTapped() {
        guard let color = colorView.backgroundColor else { return }
        delegate?.didSelectColor(color)
        
        dismiss(animated: true)
    }
    // MARK: - Private Methods
    private func setupLabels() {
        redValueLabel.text = formattedValue(from: redSlider)
        greenValueLabel.text = formattedValue(from: greenSlider)
        blueValueLabel.text = formattedValue(from: blueSlider)
    }
    
    private func setupTextField() {
        redTextField.text = formattedValue(from: redSlider)
        greenTextField.text = formattedValue(from: greenSlider)
        blueTextField.text = formattedValue(from: greenSlider)
    }
    
    private func setColor() {
        colorView.backgroundColor = UIColor(
            red: redSlider.value.cgFloat(),
            green: greenSlider.value.cgFloat(),
            blue: blueSlider.value.cgFloat(),
            alpha: 1
        )
    }
    
    private func updateColor() {
        if let colorComponents = previousScreenColor.getColors() {
            redSlider.value = Float(colorComponents.red)
            greenSlider.value = Float(colorComponents.green)
            blueSlider.value = Float(colorComponents.blue)
        }
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

