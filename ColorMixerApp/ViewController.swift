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
    
    // MARK: - Private Properties
    private var redSliderValue: CGFloat = 0.0
    private var greenSliderValue: CGFloat = 0.0
    private var blueSliderValue: CGFloat = 0.0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 20
        
        setInitialSliderValues()
        setupLabels()
        
        colorView.backgroundColor = UIColor(
            red: redSliderValue,
            green: greenSliderValue,
            blue: blueSliderValue,
            alpha: 1
        )
    }

    // MARK: - IB Actions
    @IBAction func redSliderChanged() {
        redValueLabel.text = String(format: "%.2f", redSlider.value)
        redSliderValue = CGFloat(redSlider.value)
        updateColorView()
    }
    
    @IBAction func greenSliderChanged() {
        greenValueLabel.text = String(format: "%.2f", greenSlider.value)
        greenSliderValue = CGFloat(greenSlider.value)
        updateColorView()
    }
    
    @IBAction func blueSliderChanged() {
        blueValueLabel.text = String(format: "%.2f", blueSlider.value)
        blueSliderValue = CGFloat(blueSlider.value)
        updateColorView()
    }
    
    // MARK: - Private Methods
    private func setInitialSliderValues() {
        redSliderValue = CGFloat(redSlider.value)
        greenSliderValue = CGFloat(greenSlider.value)
        blueSliderValue = CGFloat(blueSlider.value)
    }
    
    private func setupLabels() {
        redValueLabel.text = String(format: "%.2f", redSlider.value)
        greenValueLabel.text = String(format: "%.2f", greenSlider.value)
        blueValueLabel.text = String(format: "%.2f", blueSlider.value)
    }
    
    private func updateColorView() {
        colorView.backgroundColor = UIColor(
            red: redSliderValue,
            green: greenSliderValue,
            blue: blueSliderValue,
            alpha: 1
        )
    }
}

