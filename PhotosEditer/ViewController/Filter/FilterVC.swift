//
//  FilterVC.swift
//  PhotosEditer
//
//  Created by 200OK-IOS1 on 26/02/2019.
//  Copyright © 2020 2BSolution. All rights reserved.
//

import UIKit
import MediaPlayer

class FilterVC: UIViewController {

   @IBOutlet weak private var viewContent: UIView!
   @IBOutlet weak private var stackImagesList: UIStackView!
   @IBOutlet weak private var btnOpenImagesList: UIButton!
   @IBOutlet weak private var collectionImagesList: UICollectionView!
   @IBOutlet weak private var imgSelecetedImages: UIImageView!
   @IBOutlet weak private var collectionFilterList: UICollectionView!
   
   //MARK:- Variable Declaration
   private let cell = "HomeItemCell"
   var arrImages = [UIImage]()
   private var selectedIndex = 0
   private let vmObject = FilterViewModel()
   
   //MARK:- Variable Declaration
   override func viewDidLoad() {
      super.viewDidLoad()
      setTheme()
   }
   
   private func setTheme() {
      let size1 = CGSize(width: collectionImagesList.frame.width - 25, height: collectionImagesList.frame.width - 25 )
      collectionImagesList.setTheme(cell: cell, lineSpacing: 6, interitemSpacing: 3, direction: .vertical, size: size1, inset: UIEdgeInsets.init())
      collectionImagesList.dataSource = self
      collectionImagesList.delegate = self
      collectionImagesList.backgroundColor = .white
      
      let size2 = CGSize(width: collectionFilterList.frame.height - 25, height: collectionFilterList.frame.height - 25 )
      collectionFilterList.setTheme(cell: cell, lineSpacing: 10, interitemSpacing: 3, direction: .horizontal, size: size2, inset: UIEdgeInsets.init())
      collectionFilterList.dataSource = self
      collectionFilterList.delegate = self
      
      imgSelecetedImages.contentMode = .scaleAspectFit
      imgSelecetedImages.image = arrImages[selectedIndex]
      for image in arrImages {
         vmObject.arrImagesList.append(FilterImageModel(orignal: image))
      }
      viewContent.bringSubviewToFront(collectionFilterList)

      let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipRight))
      swipeRight.direction = .right
      self.view.addGestureRecognizer(swipeRight)

      let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipLeft))
      swipeLeft.direction = .left
      self.view.addGestureRecognizer(swipeLeft)
      let mediaItems = MPMediaQuery.songs().items
      print(mediaItems)
      let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
      let url = URL(fileURLWithPath: documentsPath)

      let fileManager = FileManager.default
      let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: url.path)!
      while let element = enumerator.nextObject() as? String{
         if element.hasSuffix(".mp3") {
            // do something
            print(element)
         }
      }
   }
   
   //MARK:- Actions
   @IBAction private func btnBack_click() {
      popVC()
   }
   @IBAction private func btnOpenImagesList_click() {
      collectionImagesList.isHidden ? swipRight() : swipLeft()
   }

   @objc private func swipLeft() {
      if !collectionImagesList.isHidden {
         UIView.animate(withDuration: 0.5, animations: {
            self.stackImagesList.frame.origin.x = -(self.collectionImagesList.frame.width)
         }) { (status) in
            self.collectionImagesList.isHidden = true
            self.viewContent.bringSubviewToFront(self.collectionFilterList)
         }
      }
   }

   @objc private func swipRight() {
      if collectionImagesList.isHidden {
         collectionImagesList.isHidden = false
         self.stackImagesList.frame.origin.x = -(self.collectionImagesList.frame.width)
         self.viewContent.sendSubviewToBack(self.collectionFilterList)
         self.collectionImagesList.reloadData()
         UIView.animate(withDuration: 0.5, animations: {
            self.stackImagesList.frame.origin.x = 0
         }) { (status) in }
      }
   }
}
extension FilterVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      if collectionView == collectionImagesList {
         return vmObject.arrImagesList.count
      } else {
         return vmObject.arrFilterNames.count
      }
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath) as? HomeItemCell {
         if collectionView == collectionImagesList {
            cell.setGalleryData(vmObject.arrImagesList[indexPath.row].filterImage, isSelected: selectedIndex == indexPath.row)
         } else {
            cell.setFilterData(vmObject.arrFilterNames[indexPath.row].filterImage)
         }
         return cell
      }
      return UICollectionViewCell()
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      if collectionView == collectionImagesList {
         return CGSize(width: collectionImagesList.frame.width - 25, height: collectionImagesList.frame.width - 25 )
      } else {
         return CGSize(width: collectionFilterList.frame.height - 25, height: collectionFilterList.frame.height - 25 )
      }
   }
}
extension FilterVC: UICollectionViewDelegate {
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if collectionView == collectionImagesList {
         selectedIndex = indexPath.row
         imgSelecetedImages.image = vmObject.arrImagesList[indexPath.row].filterImage
         btnOpenImagesList_click()
      } else {
         vmObject.arrImagesList[selectedIndex].filterName = vmObject.arrFilterNames[indexPath.row].filterName
         vmObject.arrImagesList[selectedIndex].filterImage = vmObject.updateFilter(object: vmObject.arrImagesList[selectedIndex])
         imgSelecetedImages.image = vmObject.arrImagesList[selectedIndex].filterImage
      }
   }
}
