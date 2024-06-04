//
//  Constants.swift
//  EleganceHub
//
//  Created by raneem on 24/05/2024.
//

import Foundation
import UIKit

class Constants {
    
    static let storeUrl = "https://mad44-ism-ios1.myshopify.com/admin/api/2024-04/"
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

enum Categories : String{
    case Men = "484444274963" //   484445028627
    case Women = "484444307731" //   484445061395
    case Kids = "484444340499" //   484445094163
    case Sale = "484444406035" //   484445126931
}
//men 484442636563 484443390227
//women 484443422995 484442669331
//kids 484442702099 484443455763
//sale 484442734867 484443488531
