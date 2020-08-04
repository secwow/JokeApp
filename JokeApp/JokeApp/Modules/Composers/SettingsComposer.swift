import DomainLogic

class SettingsComposer {
    private init() {}
    
    static func compose(service: OfflineNameReplacer) -> SettingsViewController {
        let vc = SettingsViewController()
        vc.viewModel = MySettingsViewModel(networkInstructor: service)
        
        return vc
    }
}
