import DomainLogic

class AddNewJokeComposer {
    static func compose(_ service: (JokesSavingService & AnyObject),
                        onClose: (() -> ())? = nil,
                        onSave: (() -> ())? = nil) -> AddNewJokeViewController {
        
        let vc = AddNewJokeViewController()
        vc.modalPresentationStyle = .overFullScreen
        let viewModel = AddNewJokeViewModel(service: service)
        vc.viewModel = viewModel
        
        viewModel.onSave = onSave
        viewModel.onClose = onClose
        
        return vc
    }
}
