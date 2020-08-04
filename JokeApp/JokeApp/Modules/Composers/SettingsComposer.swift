import DomainLogic

class SettingsComposer {
    private init() {}
    
    static func compose(service: ChuckNorrisProtocol) -> SettingsViewController {
        let vc = SettingsViewController()
        vc.viewModel = SettingsViewModel(networkInstructor: service)
        
        return vc
    }
}
