import UIKit

class JokeCellView: UITableViewCell {
    lazy var jokeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Like", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    var addToFavourite: (() -> ())?
    var share: ((String) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    @objc func likeTapped() {
        addToFavourite?()
    }
    
    @objc func shareTapped() {
        share?(jokeLabel.text ?? "")
     }
    
    private func commonInit() {
        addSubview(jokeLabel)
        jokeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            jokeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            jokeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            jokeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
        
        addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: jokeLabel.bottomAnchor, constant: 8),
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            likeButton.widthAnchor.constraint(equalToConstant: 90),
            likeButton.heightAnchor.constraint(equalToConstant: 50),
            likeButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        
        addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareButton.topAnchor.constraint(equalTo: jokeLabel.bottomAnchor, constant: 8),
            shareButton.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: 8),
            shareButton.widthAnchor.constraint(equalToConstant: 90),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
    }
}
