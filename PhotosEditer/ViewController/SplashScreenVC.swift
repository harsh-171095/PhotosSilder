//
//  SplashScreenVC.swift
//  PhotosEditer
//
//  Created by 200OK-IOS1 on 26/02/2019.
//  Copyright © 2020 2BSolution. All rights reserved.
//

import UIKit

class SplashScreenVC: UIViewController {

   @IBOutlet weak private var lblLogo: UILabel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      ApplicationDelegateObjc?.navigationController = self.navigationController ?? UINavigationController()
      rotate360(lblLogo, duration: 1.0, repeating: false)
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
         let controller = ViewController(id: "GalleryVC")
         MackAsRootview(controller)
      })
   }

   func rotate360(_ view: UIView, duration: TimeInterval, repeating: Bool = true) {

      let transform1 = CGAffineTransform(rotationAngle: .pi * 0.75)
      let transform2 = CGAffineTransform(rotationAngle: .pi * 1.5)

      let animationOptions: UInt
      if repeating {
         animationOptions = UIView.AnimationOptions.curveLinear.rawValue | UIView.AnimationOptions.repeat.rawValue
      } else {
         animationOptions = UIView.AnimationOptions.curveLinear.rawValue
      }

      let keyFrameAnimationOptions = UIView.KeyframeAnimationOptions(rawValue: animationOptions)

      UIView.animateKeyframes(withDuration: duration, delay: 0, options: [keyFrameAnimationOptions, .calculationModeLinear], animations: {
         UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.375) {
            view.transform = transform1
         }
         UIView.addKeyframe(withRelativeStartTime: 0.375, relativeDuration: 0.375) {
            view.transform = transform2
         }
         UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
            view.transform = .identity
         }
      }, completion: nil)
   }

}
