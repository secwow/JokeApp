import DomainLogic
import UIKit

class JokesCellViewController {
    private var viewModel: JokesCellViewModel
    private var cell: JokeCellView?
    
    init(with viewModel: JokesCellViewModel) {
        self.viewModel = viewModel
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        let cell: JokeCellView = tableView.dequeueReusableCell()
        self.cell = cell

        return binded(cell)
    }
    
    func binded(_ cell: JokeCellView) -> JokeCellView {
        cell.jokeLabel.text = viewModel.joke
        cell.addToFavourite = { [weak self] in
            self?.viewModel.addToFavourite()
        }
        cell.share = { [weak self] joke in
            self?.viewModel.share(joke)
        }
        
        return cell
    }
    
    func prepareForReuse() {
        cell = nil
    }
}
