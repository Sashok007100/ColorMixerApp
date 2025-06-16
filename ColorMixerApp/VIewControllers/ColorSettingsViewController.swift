//
//  ColorSettingsViewController.swift
//  ColorMixerApp
//
//  Created by Alexandr Artemov (Mac Mini) on 30.05.2025.
//

import UIKit

final class ColorSettingsViewController: UIViewController {
    
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
    weak var delegate: ColorSettingsDelegate?
    
    var previousScreenColor: UIColor!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
        
        colorView.layer.cornerRadius = 20
        
        addDoneButtonToTextFields()
        
        updateSlidersFromPreviousColor()
        setupLabels()
        setupTextFields()
        setColor()
    }
    
    // MARK: - Overrides
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - IB Actions
    @IBAction func sliderAction(_ sender: UISlider) {
        setColor()
        
        switch sender {
        case redSlider:
            updateUI(for: redSlider, label: redValueLabel, textField: redTextField)
        case greenSlider:
            updateUI(for: greenSlider, label: greenValueLabel, textField: greenTextField)
        default:
            updateUI(for: blueSlider, label: blueValueLabel, textField: blueTextField)
        }
    }
    
    @IBAction func doneButtonTapped() {
        guard let color = colorView.backgroundColor else { return }
        delegate?.didSelectColor(color)
        
        dismiss(animated: true)
    }
    
    // MARK: - @objc Methods
    @objc func doneTapped() {
        view.endEditing(true)
    }
    
    // MARK: - Private Methods
    private func setupLabels() {
        redValueLabel.text = formattedValue(from: redSlider)
        greenValueLabel.text = formattedValue(from: greenSlider)
        blueValueLabel.text = formattedValue(from: blueSlider)
    }
    
    private func setupTextFields() {
        redTextField.text = formattedValue(from: redSlider)
        greenTextField.text = formattedValue(from: greenSlider)
        blueTextField.text = formattedValue(from: blueSlider)
    }
    
    private func addDoneButtonToTextFields() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        
        toolBar.setItems([doneButton], animated: false)
        
        
        [redTextField, greenTextField, blueTextField].forEach {
            $0?.inputAccessoryView = toolBar
        }
    }
    
    private func setColor() {
        colorView.backgroundColor = UIColor(
            red: redSlider.value.cgFloat(),
            green: greenSlider.value.cgFloat(),
            blue: blueSlider.value.cgFloat(),
            alpha: 1
        )
    }
    
    private func updateSlidersFromPreviousColor() {
        guard let colorComponents = previousScreenColor.getColors() else { return }
        
        redSlider.value = Float(colorComponents.red)
        greenSlider.value = Float(colorComponents.green)
        blueSlider.value = Float(colorComponents.blue)
    }
    
    private func updateUI(for slider: UISlider, label: UILabel, textField: UITextField) {
        label.text = formattedValue(from: slider)
        textField.text = formattedValue(from: slider)
    }
    
    private func updateColorValue(
        from textField: UITextField,
        to slider: UISlider,
        label: UILabel
    ) {
        guard let text = textField.text?.replacingOccurrences(of: ",", with: ".") else { return  }
        
        let parts = text.split(separator: ".")
        
        let isValidFormat = (parts.first?.count ?? 0) <= 1 &&
        (parts.count < 2 || parts[1].count <= 2)
        
        guard let value = Float(text), value >= 0.0, value <= 1.0, isValidFormat else {
            showAlert(title: "Ошибка!", message: "Введите число от 0.00 до 1.00.") {
                slider.value = 0.0
                label.text = self.formattedValue(from: slider)
                textField.text = self.formattedValue(from: slider)
                self.setColor()
            }
            return
        }
        
        slider.value = value
        label.text = formattedValue(from: slider)
    }
    
    private func showAlert(
        title: String,
        message: String,
        completion: (() -> Void)?
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    private func formattedValue(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
}

extension ColorSettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case redTextField:
            updateColorValue(from: textField, to: redSlider, label: redValueLabel)
        case greenTextField:
            updateColorValue(from: textField, to: greenSlider, label: greenValueLabel)
        default:
            updateColorValue(from: textField, to: blueSlider, label: blueValueLabel)
        }
        setColor()
    }
}
