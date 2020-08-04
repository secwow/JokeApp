import Foundation

extension Router {
    func present(_ module: Presentable?) {
        present(module, animated: true)
    }
    
    func push(_ module: Presentable?)  {
        push(module, animated: true)
    }
    
    func push(_ module: Presentable?, hideBottomBar: Bool)  {
        push(module, animated: true, hideBottomBar: hideBottomBar, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool)  {
        push(module, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        push(module, animated: animated, hideBottomBar: false, completion: completion)
    }
    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }
    
    func popModule()  {
         popModule(animated: true)
     }
    
    func setRootModule(_ module: Presentable?) {
        setRootModule(module, hideBar: false)
    }
}
