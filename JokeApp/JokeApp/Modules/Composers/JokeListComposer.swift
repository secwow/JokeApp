import DomainLogic

class JokeListComposer {
    private init() {}
    
    static func compose(jokesLoader: JokesLoader,
                        jokesFavourite: JokesFavouriteService,
                        networkInstructor: NetworkInstructor,
                        shareDelegate: ShareDelegate) -> JokesListViewController {
        let vc = JokesListViewController()
        let viewModel = JokesListViewModel(jokesLoader:
            MainQueueDispatchDecorator(jokesLoader), networkInstructor: networkInstructor
        )
        
        vc.viewModel = viewModel
        viewModel.onFeedLoad = JokeListComposer.adaptJokeToCellControllers(forwardingTo: vc,
                                                                           jokesFavourite: jokesFavourite,
                                                                           shareDelegate: shareDelegate,
                                                                           viewModel: viewModel)
        
        return vc
    }
    
    private static func adaptJokeToCellControllers(forwardingTo controller: JokesListViewController,
                                                   jokesFavourite: JokesFavouriteService,
                                                   shareDelegate: ShareDelegate,
                                                   viewModel: JokesListViewModel) -> ([Joke]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map({
                JokesCellViewController(with: JokeCellViewModel(jokeModel: $0,
                                                                favouriteService: jokesFavourite,
                                                                shareDelegate: shareDelegate))
            })
        }
    }
}
