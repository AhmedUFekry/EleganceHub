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

    static func textFieldStyle(tF:UITextField){
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: tF.frame.size.height - 0.5, width: tF.frame.size.width, height: 0.5)
        bottomBorder.backgroundColor = UIColor(named: "btnColor")?.cgColor ?? UIColor.black.cgColor
        tF.layer.addSublayer(bottomBorder)
        tF.borderStyle = .none
        tF.backgroundColor = .clear
        tF.layer.masksToBounds = true
    }
    
    static func addPasswordToggleButton(to textField: UITextField, target: Any, action: Selector) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.setImage(UIImage(systemName: "eye"), for: .selected)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.contentMode = .center
        button.addTarget(target, action: action, for: .touchUpInside)
            
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
        paddingView.addSubview(button)
        
        textField.rightView = paddingView
        textField.rightViewMode = .always
    }

    static func displayAlert(viewController vc:UIViewController,message: String, seconds: Double, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        vc.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
   
    static func showAlertWithAction(on viewController:UIViewController,title:String?,message:String,isTwoBtn:Bool=false,firstBtnTitle:String="Cancel",actionBtnTitle:String,style:UIAlertAction.Style? = .default,handler:((UIAlertAction) -> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if(isTwoBtn){
            let firstBtn = UIAlertAction(title: firstBtnTitle, style: .cancel, handler: nil)
            firstBtn.setValue(UIColor(named: "btnColor") ?? UIColor.black, forKey: "titleTextColor")
            alert.addAction(firstBtn)
        }
        let secondBtn = UIAlertAction(title: actionBtnTitle, style: style!, handler:handler)
        if(style != .destructive){
            secondBtn.setValue(UIColor(named: "btnColor") ?? UIColor.black, forKey: "titleTextColor")
        }
        alert.addAction(secondBtn)
        viewController.present(alert, animated: true, completion: nil)

    }
    
}

enum Categories : String{
    case Men = "484444274963" //   484445028627
    case Women = "484444307731" //   484445061395
    case Kids = "484444340499" //   484445094163
    case Sale = "484444406035" //   484445126931
}

enum UserDefaultsConstants: String {
    case isLoggedIn
    case loggedInUserID
    case savedImage
    case hasDraftOrder
    case getDraftOrder
}
