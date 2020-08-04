import DomainLogic
import UIKit

class MyJokeCellView: UITableViewCell {
    lazy var jokeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    var delete: (() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    @objc func deleteSelected() {
        delete?()
    }
    
    private func commonInit() {
        addSubview(jokeLabel)
        jokeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            jokeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            jokeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            jokeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
        
        addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: jokeLabel.bottomAnchor, constant: 8),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            deleteButton.widthAnchor.constraint(equalToConstant: 90),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        deleteButton.addTarget(self, action: #selector(deleteSelected), for: .touchUpInside)
    }
}
