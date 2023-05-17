import Foundation
import Network

@available(iOS 13.0, *)
public actor KSReachabilityManager {

    //MARK: - Properties
    public static var shared = KSReachabilityManager()
    lazy private var monitor = NWPathMonitor()

    let queue = DispatchQueue.global(qos: .background)
    
    public var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }

    //MARK: - Methods
    public func startNetworkReachabilityObserver() {
        self.monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                NotificationCenter.default.post(name: .reachabilityIsConnected, object: true)
            } else if path.status == .unsatisfied {
                NotificationCenter.default.post(name: .reachabilityIsDisconnected, object: false)
            }
        }
        
        self.monitor.start(queue: queue)
    }
}
