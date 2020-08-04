import UIKit

class AddNewJokeViewController: UIViewController {
    private enum Constants {
        struct Container {
            static let yOffset: CGFloat = -40
            static let width: CGFloat = 200
            static let height: CGFloat = 150
        }
        
        struct Title {
            static let leadingOffset: CGFloat = 8
        }
        
        struct JokeText {
            static let offset: CGFloat = 8
        }
        
        struct ButtonStack {
            static let offset: CGFloat = 8
            static let height: CGFloat = 40
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Add new jokes"
        return label
    }()
    
    lazy var jokeTextView: UITextView = {
        let textView = UITextView()
        return textView
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    var viewModel: AddNewJokeViewModel?
    
    var cancel: (() -> ())?
    var save: ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTargets()
        hideKeyboardWhenTappedAround()
    }
    
    func setupTargets() {
        saveButton.addTarget(self, action: #selector(saveSelected), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelSelected), for: .touchUpInside)
    }
    
    func setupUI() {
        let containerView = UIView()
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.cgColor
        
        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                   constant: Constants.Container.yOffset),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: Constants.Container.width),
            containerView.heightAnchor.constraint(equalToConstant: Constants.Container.height)
        ])
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Title.leadingOffset),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        jokeTextView.translatesAutoresizingMaskIntoConstraints = false
        jokeTextView.layer.borderWidth = 1
        jokeTextView.layer.borderColor = UIColor.white.cgColor
        containerView.addSubview(jokeTextView)
        NSLayoutConstraint.activate([
            jokeTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                              constant: Constants.JokeText.offset),
            jokeTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                  constant: Constants.JokeText.offset),
            jokeTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                   constant: -Constants.JokeText.offset)
        ])
        
        let buttonsStack = UIStackView()
        buttonsStack.distribution = .fillEqually
        buttonsStack.axis = .horizontal
        buttonsStack.alignment = .fill
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.addArrangedSubview(saveButton)
        buttonsStack.addArrangedSubview(cancelButton)
        containerView.addSubview(buttonsStack)
        NSLayoutConstraint.activate([
            buttonsStack.topAnchor.constraint(equalTo: jokeTextView.bottomAnchor,
                                              constant: Constants.ButtonStack.offset),
            buttonsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                  constant: Constants.ButtonStack.offset),
            buttonsStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                   constant: -Constants.ButtonStack.offset),
            buttonsStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                 constant: Constants.ButtonStack.offset),
            buttonsStack.heightAnchor.constraint(equalToConstant: Constants.ButtonStack.height)
        ])
    }
    
    @objc func cancelSelected() {
        viewModel?.close()
    }
    
    @objc func saveSelected() {
        viewModel?.saveJoke(joke: jokeTextView.text)
    }
}
