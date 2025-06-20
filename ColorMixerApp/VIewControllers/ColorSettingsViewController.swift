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
        
        updateSlidersFromPreviousColor()
        setupLabels()
        setupTextFields()
        setPreviewColor()
    }
    
    // MARK: - Overrides
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - IB Actions
    @IBAction func sliderAction(_ sender: UISlider) {
        setPreviewColor()
        
        switch sender {
        case redSlider:
            updateLabel(for: redSlider, label: redValueLabel)
            updateTextField(for: redSlider, textField: redTextField)
        case greenSlider:
            updateLabel(for: greenSlider, label: greenValueLabel)
            updateTextField(for: greenSlider, textField: greenTextField)
        default:
            updateLabel(for: blueSlider, label: blueValueLabel)
            updateTextField(for: blueSlider, textField: blueTextField)
        }
    }
    
    @IBAction func doneButtonTapped() {
        guard let color = colorView.backgroundColor else { return }
        delegate?.setColor(color)
        
        dismiss(animated: true)
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
    
    private func setPreviewColor() {
        colorView.backgroundColor = UIColor(
            red: redSlider.value.cgFloat(),
            green: greenSlider.value.cgFloat(),
            blue: blueSlider.value.cgFloat(),
            alpha: 1
        )
    }
    
    private func updateSlidersFromPreviousColor() {
        let colorComponents = CIColor(color: previousScreenColor)
        
        redSlider.value = Float(colorComponents.red)
        greenSlider.value = Float(colorComponents.green)
        blueSlider.value = Float(colorComponents.blue)
    }
    
    private func updateLabel(for slider: UISlider, label: UILabel) {
        label.text = formattedValue(from: slider)
    }
    
    private func updateTextField(for slider: UISlider, textField: UITextField) {
        textField.text = formattedValue(from: slider)
    }
    
    private func updateColorValue(
        from textField: UITextField,
        to slider: UISlider,
        label: UILabel
    ) {
        guard let text = textField.text?.replacingOccurrences(of: ",", with: ".") else { return  }
        
        let pattern = #"^(0(\.\d{1,2})?|1(\.0{1,2})?)$"#
        let isValueValid = NSPredicate(format: "SELF MATCHES %@", pattern)
            .evaluate(with: text)
        
        guard let value = Float(text), isValueValid else {
            showAlert(
                title: "Ошибка!",
                message: "Введите число от 0.00 до 1.00."
            ) {
                slider.value = 0.0
                label.text = self.formattedValue(from: slider)
                textField.text = self.formattedValue(from: slider)
                self.setPreviewColor()
                return
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: textField,
            action: #selector(resignFirstResponder)
        )
        
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        toolBar.items = [flexBarButton, doneButton]
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case redTextField:
            updateColorValue(from: textField, to: redSlider, label: redValueLabel)
        case greenTextField:
            updateColorValue(from: textField, to: greenSlider, label: greenValueLabel)
        default:
            updateColorValue(from: textField, to: blueSlider, label: blueValueLabel)
        }
        setPreviewColor()
    }
}
