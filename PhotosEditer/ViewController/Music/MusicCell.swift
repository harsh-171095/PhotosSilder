//
//  MusicCell.swift
//  PhotosEditer
//
//  Created by 200OK-IOS1 on 26/02/2019.
//  Copyright © 2020 2BSolution. All rights reserved.
//

import UIKit

class MusicCell: UITableViewCell {

   @IBOutlet weak private var lblMusicTitle: UILabel!
   @IBOutlet weak private var viewIsPlay: UIView!

   private let radarAnimation = "radarAnimation"
   private var animationLayer: CALayer?
   private var animationGroup: CAAnimationGroup?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      selectionStyle = .none
    }

   func setData(title: URL, isPlay: Bool = false) {
      lblMusicTitle.text = title.lastPathComponent
      if  isPlay {
         let height = viewIsPlay.bounds.width / 2.2
         let width = viewIsPlay.bounds.width / 2.2
         let newX = (viewIsPlay.bounds.width/2) - (width/2)
         let newY = (viewIsPlay.bounds.width/2) - (width/2)
         let frameLayer = CGRect(x: newX, y: newY, width: height, height: width)
         let first = makeRadarAnimation(showRect: frameLayer, isRound: true) //Location and size
         viewIsPlay.layer.addSublayer(first)
      } else {
         viewIsPlay.layer.removeAllAnimations()
      }
      bringSubviewToFront(lblMusicTitle)
   }
   private func makeRadarAnimation(showRect: CGRect, isRound: Bool) -> CALayer {
                // 1. A dynamic wave
       let shapeLayer = CAShapeLayer()
       shapeLayer.frame = showRect
                // showRect maximum inscribed circle

       shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: showRect.width, height: showRect.height)).cgPath

      shapeLayer.fillColor = UIColor.red.withAlphaComponent(0.5).cgColor //Ripple color

                shapeLayer.opacity = 0.0 // default initial color transparency

       animationLayer = shapeLayer

                // 2. Need to repeat the dynamic wave, that is, create a copy
       let replicator = CAReplicatorLayer()
       replicator.frame = shapeLayer.bounds
       replicator.instanceCount = 4
       replicator.instanceDelay = 1.0
       replicator.addSublayer(shapeLayer)

                // 3. Create an animation group
       let opacityAnimation = CABasicAnimation(keyPath: "opacity")
                opacityAnimation.fromValue = NSNumber(floatLiteral: 1.0) // Start transparency
                opacityAnimation.toValue = NSNumber(floatLiteral: 0) // Transparent bottom at the end

       let scaleAnimation = CABasicAnimation(keyPath: "transform")
       if isRound {
                        scaleAnimation.fromValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0)) // Zoom start size
       } else {
                        scaleAnimation.fromValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 0)) // Zoom start size
       }
                scaleAnimation.toValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 2.0, 2.0, 0)) // Zoom end size

       let animationGroup = CAAnimationGroup()
       animationGroup.animations = [opacityAnimation, scaleAnimation]
                animationGroup.duration = 3.0 // Animation execution time
                animationGroup.repeatCount = HUGE // maximum repeat
       animationGroup.autoreverses = false

       self.animationGroup = animationGroup

       shapeLayer.add(animationGroup, forKey: radarAnimation)

       return replicator
   }

}
