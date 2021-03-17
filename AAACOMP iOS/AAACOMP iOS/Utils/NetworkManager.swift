//
//  NetworkManager.swift
//  AAACOMPiOS
//
//  Created by Rafael Escaleira on 21/04/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import Foundation
import Reachability

class NetworkManager: NSObject {
    
    var reachability: Reachability!
    
    static let sharedInstance: NetworkManager = { return NetworkManager() }()
    
    override init() {
        super.init()
    
        do {
            
            reachability = try Reachability()
            NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: .reachabilityChanged, object: reachability)
            try reachability.startNotifier()
        }
        
        catch { print("Unable to start notifier") }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {  }
    
    static func stopNotifier() -> Void {
        
        do { try (NetworkManager.sharedInstance.reachability).startNotifier()  }
            
        catch { print("Error stopping notifier") }
    }
    
    static func hasInternetConnection() -> Bool {
        
        var hasConnection: Bool = false
        
        NetworkManager.isReachable { (_) in hasConnection = true }
        
        return hasConnection
    }
    
    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
        
        if (NetworkManager.sharedInstance.reachability).connection != .unavailable {
            
            completed(NetworkManager.sharedInstance)
        }
    }
    
    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
        
        if (NetworkManager.sharedInstance.reachability).connection == .unavailable {
            
            completed(NetworkManager.sharedInstance)
        }
    }
    
    static func isReachableViaCellular(completed: @escaping (NetworkManager) -> Void) {
        
        if (NetworkManager.sharedInstance.reachability).connection == .cellular {
            
            completed(NetworkManager.sharedInstance)
        }
    }
    
    static func isReachableViaWiFi(completed: @escaping (NetworkManager) -> Void) {
        
        if (NetworkManager.sharedInstance.reachability).connection == .wifi {
            
            completed(NetworkManager.sharedInstance)
        }
    }
}
