import UIKit
import DomainLogic

class SettingsViewController: UIViewController {
    enum Constants {
        enum FirstNameTextField {
            static let offset: CGFloat = 16
            static let height: CGFloat = 60
        }
        
        enum LastNameTextField {
             static let offset: CGFloat = 16
             static let height: CGFloat = 60
        }
        
        enum OfflineLabel {
             static let offset: CGFloat = 16
             static let height: CGFloat = 60
        }
        
        enum NetworkSwitcher {
             static let trailingOffset: CGFloat = 16
        }
        
        enum TextFields {
            static let cornerRadius: CGFloat = 5
            static let borderWidth: CGFloat = 1
        }
    }
    
    lazy var firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Character first name"
        textField.textColor = .red
        return textField
    }()
    
    lazy var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Character last name"
        textField.textColor = .red
        return textField
    }()
    
    lazy var offlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Offline mode"
        label.textColor = .red
        return label
    }()
    
    lazy var networkSwitcher: UISwitch = {
        let networkSwitcher = UISwitch()
        return networkSwitcher
    }()
    
    var viewModel: MySettingsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTargets()
        hideKeyboardWhenTappedAround()
    }
    
    func setup(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = Constants.TextFields.borderWidth
        textField.layer.cornerRadius = Constants.TextFields.cornerRadius
    }
    
    // MARK: UI setup
    func setupUI() {
        setup(firstNameTextField)
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstNameTextField)
        NSLayoutConstraint.activate([
            firstNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.FirstNameTextField.offset),
            firstNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.FirstNameTextField.offset),
            firstNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.FirstNameTextField.offset),
            firstNameTextField.heightAnchor.constraint(equalToConstant: Constants.FirstNameTextField.height)
        ])
        
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        setup(lastNameTextField)
        view.addSubview(lastNameTextField)
        NSLayoutConstraint.activate([
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: Constants.LastNameTextField.offset),
            lastNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.LastNameTextField.offset),
            lastNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.LastNameTextField.offset),
            lastNameTextField.heightAnchor.constraint(equalToConstant: Constants.LastNameTextField.height)
        ])
        
        offlineLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(offlineLabel)
        NSLayoutConstraint.activate([
            offlineLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: Constants.OfflineLabel.offset),
            offlineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.OfflineLabel.offset),
            offlineLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.OfflineLabel.offset),
            offlineLabel.heightAnchor.constraint(equalToConstant: Constants.OfflineLabel.height)
        ])
        
        networkSwitcher.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(networkSwitcher)
        NSLayoutConstraint.activate([
            networkSwitcher.centerYAnchor.constraint(equalTo: offlineLabel.centerYAnchor),
            networkSwitcher.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.NetworkSwitcher.trailingOffset),
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
