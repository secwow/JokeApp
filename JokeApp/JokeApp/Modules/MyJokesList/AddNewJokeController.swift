import UIKit

class AddNewJokeViewController: UIViewController {
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
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        return button
    }()
    
    var viewModel: AddNewJokeViewModel?
    
    var cancel: (() -> ())?
    var save: ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let containerView = UIView()
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.cgColor
        
        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 200),
            containerView.heightAnchor.constraint(equalToConstant: 150)
        ])
        

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        jokeTextView.translatesAutoresizingMaskIntoConstraints = false
        jokeTextView.layer.borderWidth = 1
        jokeTextView.layer.borderColor = UIColor.white.cgColor
        containerView.addSubview(jokeTextView)
        NSLayoutConstraint.activate([
            jokeTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            jokeTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            jokeTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: jokeTextView.bottomAnchor, constant: 8),
            saveButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            saveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        saveButton.addTarget(self, action: #selector(saveSelected), for: .touchUpInside)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: jokeTextView.bottomAnchor, constant: 8),

            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24)
        ])
        cancelButton.addTarget(self, action: #selector(cancelSelected), for: .touchUpInside)
        
        hideKeyboardWhenTappedAround()
    }
    
    @objc func cancelSelected() {
        cancel?()
    }
    
    @objc func saveSelected() {
        viewModel?.saveJoke(joke: jokeTextView.text)
        save?(jokeTextView.text)
    }
}
