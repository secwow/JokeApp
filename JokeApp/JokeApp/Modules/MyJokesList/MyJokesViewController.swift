import UIKit

public final class MyJokesViewController: UIViewController {
    private enum Constants {
        struct AddButton {
            static let cornerRadius: CGFloat = 30
            static let trailingOffset: CGFloat = -30
            static let bottomOffset: CGFloat = -30
            static let width: CGFloat = 60
            static let height: CGFloat = 60
        }
    }
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.AddButton.cornerRadius
        button.backgroundColor = .orange
        button.setTitle("+", for: .normal)
        return button
    }()
    
    var addNewJoke: (() -> ())?
    
    let listController: MyJokesListViewController
    
    init(with listController: MyJokesListViewController) {
        self.listController = listController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        setupListController()
        setupAddButton()
    }
    
    // MARK: UI setup
    func setupListController() {
        addChild(listController)
        listController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(listController.view)
        
        NSLayoutConstraint.activate([
            listController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            listController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        listController.didMove(toParent: self)
    }
    
    func setupAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: Constants.AddButton.trailingOffset),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: Constants.AddButton.bottomOffset),
            addButton.widthAnchor.constraint(equalToConstant: Constants.AddButton.width),
            addButton.heightAnchor.constraint(equalToConstant: Constants.AddButton.height)
        ])
        addButton.addTarget(self, action: #selector(addNewJokeSelected), for: .touchUpInside)
    }
    
    @objc func addNewJokeSelected() {
        addNewJoke?()
    }
}
