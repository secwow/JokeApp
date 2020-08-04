import DomainLogic

class MyJokeListComposer {
    private init() {}
    
    static func compose(jokesLoader: JokesLoader,
                        jokesDeletionService: JokesDeletionService) -> (viewController: MyJokesViewController, viewModel: MyJokesListViewModel) {
        
        let vc = MyJokesListViewController()
        let viewModel = MyJokesListViewModel(jokesLoader:
            MainQueueDispatchDecorator(jokesLoader)
        )
        
        vc.viewModel = viewModel
        viewModel.onFeedLoad = MyJokeListComposer.adaptJokeToCellControllers(forwardingTo: vc,
                                                                             jokesDeletionService: jokesDeletionService,
                                                                             listViewModel: viewModel,
                                                                           viewModel: viewModel)
        let container = MyJokesViewController(with: vc)
        return (container, viewModel)
    }
    
    private static func adaptJokeToCellControllers(forwardingTo controller: MyJokesListViewController,
                                                   jokesDeletionService: JokesDeletionService,
                                                   listViewModel: MyJokesListViewModel,
                                                   viewModel: MyJokesListViewModel) -> ([Joke]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map({
                let viewModel = MyJokeCellViewModel(jokeModel: $0, favouriteService: jokesDeletionService)
                viewModel.onDelete = { [weak listViewModel] in
                    listViewModel?.loadFeed()
                }
                return MyJokesCellViewController(with: viewModel)
            })
        }
    }
}
