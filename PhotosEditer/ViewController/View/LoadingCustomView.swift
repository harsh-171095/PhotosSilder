//
//  LoadingCustomView.swift
//  BitSimple
//
//  Created by webclues-mac on 01/01/19.
//  Copyright © 2019 webclues-mac. All rights reserved.
//

import UIKit

class LoadingCustomView: UIView {
    @IBOutlet weak private var viewContent: UIView!

    class func createObject(with title: String) -> LoadingCustomView {
        let myClassNib = UINib(nibName: "LoadingCustomView", bundle: nil)
        let LoadingAlert = myClassNib.instantiate(withOwner: nil, options: nil)[0] as! LoadingCustomView
        LoadingAlert.setTheme()
        return LoadingAlert
    }
    private func setTheme() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
      viewContent.layer.cornerRadius = 15
    }

    func removeFromSuperviewAnimation() {
        removeFromSuperview()
    }
}

func showLoader(with title: String = "Loading...") {
    if let keyWindow = UIApplication.shared.keyWindow {
        if let view = keyWindow.viewWithTag(554420) as? LoadingCustomView {
            view.removeFromSuperview()
        } else {
            let Loading_view = LoadingCustomView.createObject(with: title)
            Loading_view.tag = 554420
            if #available(iOS 11.0, *) {
                Loading_view.frame = ApplicationDelegateObjc?.navigationController.topViewController?.view.bounds ?? CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
            } else {
                Loading_view.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
            }
         ApplicationDelegateObjc?.window?.addSubview(Loading_view)
        }
    }
}

func hideLoader() {
    DispatchQueue.main.async {
        if let keyWindow = ApplicationDelegateObjc?.window, let view = keyWindow.viewWithTag(554420) as? LoadingCustomView {
            view.removeFromSuperview()
        }
    }
}
