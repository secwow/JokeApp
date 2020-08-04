import UIKit

class JokeCellView: UITableViewCell {
    private enum Constants {
        struct JokeLabel {
            static let offset: CGFloat = 8
        }
        
        struct ButtonStack {
            static let offset: CGFloat = 8
            static let height: CGFloat = 50
            static let width: CGFloat = 180
        }
    }
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
            jokeLabel.topAnchor.constraint(equalTo: topAnchor,
                                           constant: Constants.JokeLabel.offset),
            jokeLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: Constants.JokeLabel.offset),
            jokeLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -Constants.JokeLabel.offset)
        ])
        
        let buttonsStack = UIStackView()
        buttonsStack.distribution = .fillEqually
        buttonsStack.axis = .horizontal
        buttonsStack.alignment = .fill
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.addArrangedSubview(likeButton)
        buttonsStack.addArrangedSubview(shareButton)
        
        self.addSubview(buttonsStack)
        NSLayoutConstraint.activate([
            buttonsStack.topAnchor.constraint(equalTo: jokeLabel.bottomAnchor,
                                              constant: Constants.ButtonStack.offset),
            buttonsStack.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: -Constants.ButtonStack.offset),
            buttonsStack.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                 constant: Constants.ButtonStack.offset),
            buttonsStack.heightAnchor.constraint(equalToConstant: Constants.ButtonStack.height),
            buttonsStack.widthAnchor.constraint(equalToConstant: Constants.ButtonStack.width)
        ])
        
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
    }
}
