//
//  NetWorkManager.swift
//  EleganceHub
//
//  Created by AYA on 22/06/2024.
//

import Foundation
import Reachability

protocol NetworkStatusProtocol {
    func networkStatusDidChange(connected: Bool)
}

class NetworkManager{
    let reachability = try! Reachability()
    var status:NetworkStatusProtocol?
        
    init(vc:NetworkStatusProtocol) {
        status = vc
        setUpReachability()
    }
    
    private func setUpReachability() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(notification:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    @objc func reachabilityChanged(notification: Notification) {
        guard let reachability = notification.object as? Reachability else {
            return
        }

        if reachability.connection != .unavailable {
            print("Device is connected to the network")
            status?.networkStatusDidChange(connected: true)
        } else {
            print("Device is not connected to the network")
            status?.networkStatusDidChange(connected: false)
        }
    }
}
protocol ConnectivityProtocol {
    var isConnected:Bool? {get}
    var networkPresenter :NetworkManager? {get set}
}

class ConnectivityUtils {
    
    static func showConnectivityAlert(from viewController: UIViewController){
       
        let alertController = UIAlertController(title: "Wi-Fi Needed", message: "Please enable Wi-Fi to continue.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Go to Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    if success {
                        print("Successfully opened settings.")
                    } else {
                        // Handle failure
                        let failureAlert = UIAlertController(title: "Error", message: "Unable to open settings.", preferredStyle: .alert)
                        failureAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        viewController.present(failureAlert, animated: true, completion: nil)
                    }
                })
            }
        }
        settingsAction.setValue(UIColor(named: "btnColor") ?? UIColor.black, forKey: "titleTextColor")

        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,handler: nil)
        
        cancelAction.setValue(UIColor(named: "btnColor") ?? UIColor.black, forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
  
}
