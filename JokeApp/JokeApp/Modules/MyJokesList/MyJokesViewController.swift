import UIKit

public final class MyJokesViewController: UIViewController {
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 30
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
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            addButton.widthAnchor.constraint(equalToConstant: 60),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        addButton.addTarget(self, action: #selector(addNewJokeSelected), for: .touchUpInside)
    }
    
    @objc func addNewJokeSelected() {
        addNewJoke?()
    }
}
