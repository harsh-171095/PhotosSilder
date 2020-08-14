//
//  Static.swift
//  PhotosEditer
//
//  Created by 200OK-IOS1 on 26/02/2019.
//  Copyright © 2020 2BSolution. All rights reserved.
//

import Foundation
import UIKit

let ApplicationDelegateObjc = UIApplication.shared.delegate as? AppDelegate

struct ScreenSize {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}

func ViewController(storyborad: String = "Main",id: String)-> UIViewController {
   let storyborad = UIStoryboard.init(name: storyborad, bundle: nil)
   return storyborad.instantiateViewController(withIdentifier: id)
}

func popVC(_ animated: Bool = true) {
    ApplicationDelegateObjc?.navigationController.popViewController(animated: animated)
}

func popToRootVC(_ animated: Bool = true) {
    ApplicationDelegateObjc?.navigationController.popToRootViewController(animated: animated)
}

func pushVC(_ viewController : UIViewController, animation : Bool = true) {
    ApplicationDelegateObjc?.navigationController.pushViewController(viewController, animated: animation)
}

func MackAsRootview(_ viewController : UIViewController) {
    ApplicationDelegateObjc?.navigationController = UINavigationController(rootViewController: viewController)
    ApplicationDelegateObjc?.navigationController.navigationBar.isHidden = true
    ApplicationDelegateObjc?.navigationController.interactivePopGestureRecognizer!.isEnabled = false

    if let window = ApplicationDelegateObjc?.window {
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light
        }
        window.rootViewController = ApplicationDelegateObjc?.navigationController
        window.backgroundColor = .white
        window.makeKeyAndVisible()
    } else{
        if let keyWindow = UIApplication.shared.keyWindow {
            ApplicationDelegateObjc?.window = keyWindow
            if #available(iOS 13.0, *) {
                ApplicationDelegateObjc?.window?.overrideUserInterfaceStyle = .light
            }
            ApplicationDelegateObjc?.window?.rootViewController = ApplicationDelegateObjc?.navigationController
            ApplicationDelegateObjc?.window?.backgroundColor = .white
            ApplicationDelegateObjc?.window?.makeKeyAndVisible()
        } else {
            ApplicationDelegateObjc?.window = UIWindow(frame: UIScreen.main.bounds)
            if #available(iOS 13.0, *) {
                ApplicationDelegateObjc?.window?.overrideUserInterfaceStyle = .light
            }
            ApplicationDelegateObjc?.window?.rootViewController = ApplicationDelegateObjc?.navigationController
            ApplicationDelegateObjc?.window?.backgroundColor = .white
            ApplicationDelegateObjc?.window?.makeKeyAndVisible()
        }
    }
}
