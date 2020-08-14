//
//  HomeItemCell.swift
//  Kika
//
//  Created by webclues on 10/06/20.
//  Copyright © 2020 webclues. All rights reserved.
//

import UIKit
import Photos

class HomeItemCell: UICollectionViewCell {
   
   @IBOutlet weak private var imgThumbnil: UIImageView!
   @IBOutlet weak private var imgSelectedIcon: UIImageView!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      setTheme()
   }
   
   private func setTheme() {
      imgThumbnil.layer.cornerRadius = 10
      imgSelectedIcon.isHidden = true
   }
   
   
   func setGalleryData(_ object: PHAsset, isSelected: Bool = false) {
      imgThumbnil.fetchImage(asset: object, contentMode: .aspectFit, targetSize: imgThumbnil.frame.size)
      imgThumbnil.layer.borderWidth = 0.05
      imgThumbnil.layer.borderColor = UIColor.black.cgColor
      imgSelectedIcon.isHidden = !isSelected
   }
   
   func setGalleryData(_ object: UIImage, isSelected: Bool = false) {
      imgThumbnil.image = object
      imgThumbnil.contentMode = .scaleAspectFill
      imgThumbnil.layer.borderWidth = 0.05
      imgThumbnil.layer.borderColor = UIColor.black.cgColor
      imgSelectedIcon.isHidden = !isSelected
   }

   func setFilterData(_ object: UIImage, isSelected: Bool = false) {
      setGalleryData(object, isSelected: isSelected)
      imgThumbnil.contentMode = .scaleAspectFill
   }
}
