//
//  Constants.swift
//  EleganceHub
//
//  Created by raneem on 24/05/2024.
//

import Foundation
import UIKit

class Constants {
    static let storeUrl = "https:mad44-ism-ios1.myshopify.com/admin/api/2024-04/"
    static let accessToken = "access_token=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"
    static let accessTokenKey = "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"
    
    static func displayToast(viewController vc:UIViewController,message msg: String, seconds sec: Double) {
            let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
            vc.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + sec) {
                alert.dismiss(animated: true)
            }
        }
}
