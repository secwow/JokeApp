import DomainLogic

class SettingsComposer {
    private init() {}
    
    static func compose(service: ChuckNorrisProtocol) -> SettingsViewController {
        let vc = SettingsViewController()
        vc.viewModel = MySettingsViewModel(networkInstructor: service)
        
        return vc
    }
}
