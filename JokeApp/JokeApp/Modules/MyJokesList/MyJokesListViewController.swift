import UIKit

public final class MyJokesListViewController: UITableViewController {
    var viewModel: FeedLoaderViewModel?
    
    var tableModel = [MyJokesCellViewController]() {
        didSet { tableView.reloadData() }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.tableView.register(MyJokeCellView.self, forCellReuseIdentifier: "\(MyJokeCellView.self)")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.loadFeed()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableModel[indexPath.row].view(in: tableView)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row < tableModel.count else {
            return
        }
        
        tableModel[indexPath.row].prepareForReuse()
    }
}
