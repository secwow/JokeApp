import UIKit
import DomainLogic

class SettingsViewController: UIViewController {
    lazy var firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Character first name"
        return textField
    }()
    
    lazy var lastNameTextField: UITextField = {
         let textField = UITextField()
         textField.placeholder = "Character last name"
         return textField
     }()
    
    lazy var offlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Offline mode"
        return label
    }()
    
    lazy var networkSwitcher: UISwitch = {
        let networkSwitcher = UISwitch()
        
        return networkSwitcher
    }()
    
    var viewModel: SettingsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTargets()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: UI setup
    func setupUI() {
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.layer.borderColor = UIColor.black.cgColor
        firstNameTextField.layer.borderWidth = 1
        firstNameTextField.layer.cornerRadius = 5
        view.addSubview(firstNameTextField)
        NSLayoutConstraint.activate([
            firstNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            firstNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            firstNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.layer.borderColor = UIColor.black.cgColor
        lastNameTextField.layer.borderWidth = 1
        lastNameTextField.layer.cornerRadius = 5
        view.addSubview(lastNameTextField)
        NSLayoutConstraint.activate([
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 16),
            lastNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lastNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        offlineLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(offlineLabel)
        NSLayoutConstraint.activate([
            offlineLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 16),
            offlineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            offlineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            offlineLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        networkSwitcher.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(networkSwitcher)
        NSLayoutConstraint.activate([
            networkSwitcher.centerYAnchor.constraint(equalTo: offlineLabel.centerYAnchor),
            networkSwitcher.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    // MARK: Setup targets
    func setupTargets() {
        lastNameTextField.addTarget(self, action: #selector(updateState), for: .editingChanged)
        firstNameTextField.addTarget(self, action: #selector(updateState), for: .editingChanged)
        networkSwitcher.addTarget(self, action: #selector(changeNetworkState), for: .valueChanged)
    }
    
    // MARK: Target methods
    @objc func changeNetworkState() {
        viewModel?.switchNetwork(on: networkSwitcher.isOn)
    }
    
    @objc func updateState() {
        guard firstNameTextField.text?.isEmpty == false && lastNameTextField.text?.isEmpty == false else {
            return
        }
        
        viewModel?.update(name: "\(firstNameTextField.text!) \(lastNameTextField.text!)")
    }
}
