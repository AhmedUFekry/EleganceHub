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
    static let customerId = "customerId"
    
    static func displayToast(viewController vc:UIViewController,message msg: String, seconds sec: Double) {
            let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
            vc.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + sec) {
                alert.dismiss(animated: true)
            }
        }

    static func textFieldStyle(tF:UITextField){
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: tF.frame.size.height - 1, width: tF.frame.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor.black.cgColor
        tF.layer.addSublayer(bottomBorder)
        tF.layer.masksToBounds = true
    }

    static func displayAlert(viewController vc:UIViewController,message: String, seconds: Double, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        vc.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
}

enum Categories : String{
    case Men = "484444274963" //   484445028627
    case Women = "484444307731" //   484445061395
    case Kids = "484444340499" //   484445094163
    case Sale = "484444406035" //   484445126931
}

enum UserDefaultsConstants:String{
    case isLoggedIn = "isLoggedIn"
    case loggedInUserID = "loggedInUserID"
    case savedImage = "savedImage"
    case hasDraftOrder = "hasDraftOrder"
    case getDraftOrder = "getDraftOrder"
}
