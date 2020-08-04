import DomainLogic
import UIKit

class MyJokesCellViewController {
    private var viewModel: MyJokeCellViewModel
    private var cell: MyJokeCellView?
    
    init(with viewModel: MyJokeCellViewModel) {
        self.viewModel = viewModel
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        let cell: MyJokeCellView = tableView.dequeueReusableCell()
        self.cell = cell

        return binded(cell)
    }
    
    func binded(_ cell: MyJokeCellView) -> MyJokeCellView {
        cell.jokeLabel.text = viewModel.joke
        cell.delete = { [weak self] in
            self?.viewModel.delete()
        }
        
        return cell
    }
    
    func prepareForReuse() {
        cell = nil
    }
}
