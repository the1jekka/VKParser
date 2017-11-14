//
//  ViewController.swift
//  VKParser
//
//  Created by Admin on 09.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

var scope = Array<String>()

class ViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate {
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.navigationController?.topViewController?.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        let vkCaptchaViewController = VKCaptchaViewController.captchaControllerWithError(captchaError)
        vkCaptchaViewController?.present(in: navigationController?.topViewController)
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if (result.token != nil) {
            self.startWorking()
        } else if (result.error != nil) {
            let alertController = UIAlertController(title: "Error", message: result.error.localizedDescription, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (result) in
                print("OK")
            })
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        let alertController = UIAlertController(title: "Error", message: "Access denied", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (result) in
            print("OK")
        })
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        navigationController?.popToRootViewController(animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scope = [VK_PER_WALL, VK_PER_GROUPS, VK_PER_VIDEO, VK_PER_AUDIO]
        view.backgroundColor = .white
        VKSdk.initialize(withAppId: "6253615").register(self)
        VKSdk.instance().uiDelegate = self
        VKSdk.authorize(scope)
        VKSdk.wakeUpSession(scope) { (authState, error) in
            if let errorMessage = error {
                let alertController = UIAlertController(title: "Error", message: errorMessage.localizedDescription, preferredStyle: .alert)
               
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (result) in
                    print("OK")
                })
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else if authState == VKAuthorizationState.authorized {
                print("Auth OK")
            }
        }
        /*self.present(SearchViewController(), animated: true, completion: nil)
        view.addSubview(userGroupSegmentedControl)
        
        setupUserGroupSegmentedControl()*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let searchViewController = SearchViewController()
        searchViewController.viewController = self
        self.present(searchViewController, animated: true, completion: nil)
    }

    func startWorking() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

