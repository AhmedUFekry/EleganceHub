//
//  WelcomeViewController.swift
//  EleganceHub
//
//  Created by Shimaa on 23/05/2024.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaultsHelper.shared.isLoggedIn() {
            navigateToHome()
        }
    }
    
    @IBAction func navigateToHomeAsGuest(_ sender: Any){        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? UITabBarController {
            tabBarController.modalPresentationStyle = .fullScreen
            present(tabBarController, animated: true, completion: nil)
        }
    }
    
  
    @IBAction func navigateToSignUpView(_ sender: Any) {
        if let signUpViewController = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
                navigationController?.pushViewController(signUpViewController, animated: true)
            }
    }
    
    @IBAction func NavigateToLoginView(_ sender: Any) {
        if let loginViewController = storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController{
            navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
    
    private func navigateToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? UITabBarController {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = tabBarController
                window.makeKeyAndVisible()
                
                let options: UIView.AnimationOptions = .transitionFlipFromRight
                UIView.transition(with: window, duration: 0.5, options: options, animations: {}, completion: nil)
            }
        }
    }
}
