import DomainLogic

class AddNewJokeComposer {
    static func compose(_ service: JokesSavingService) -> AddNewJokeViewController {
        let vc = AddNewJokeViewController()
        vc.viewModel = .init(service: service)
        
        return vc
    }
}
