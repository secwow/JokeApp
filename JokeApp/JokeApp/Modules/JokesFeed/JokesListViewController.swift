import UIKit

public final class JokesListViewController: UITableViewController {
    var viewModel: JokesListViewModel? {
        didSet { bind() }
    }
    
    var tableModel = [JokesCellViewController]() {
        didSet { tableView.reloadData() }
    }
    
    public override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.tableView.register(JokeCellView.self, forCellReuseIdentifier: "\(JokeCellView.self)")
        viewModel?.loadFeed()
        self.becomeFirstResponder()
    }
    
    private func bind() {
        viewModel?.onLoadingStateChange = { isLoading in
            if isLoading {
                
            } else {
                
            }
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == tableModel.count - 1 {
            viewModel?.loadNext()
        }
        return tableModel[indexPath.row].view(in: tableView)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row < tableModel.count else {
            return
        }
        
        tableModel[indexPath.row].prepareForReuse()
    }
}

extension JokesListViewController {
    public override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            viewModel?.loadFeed()
        }
    }
}
