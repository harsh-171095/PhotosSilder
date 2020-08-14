//
//  ViewController.swift
//  PhotosEditer
//
//  Created by 200OK-IOS1 on 26/02/2019.
//  Copyright © 2020 2BSolution. All rights reserved.
//

import UIKit
import Photos

class GalleryVC: UIViewController {

   @IBOutlet weak private var collectionItems: UICollectionView!

   //MARK:- Variable Declaration
   var allPhotos : PHFetchResult<PHAsset>?
   var selectedPhotos = [Int]()
   private let cell = "HomeItemCell"

   //MARK:- ViewController Lifecycle
   override func viewDidLoad() {
      super.viewDidLoad()
      getAllPhotos()
      setTheme()
   }

   private func setTheme() {
      let size1 = CGSize(width: (self.view.frame.width / 4) , height: (self.view.frame.width / 4) )
      collectionItems.setTheme(cell: cell, lineSpacing: 6, interitemSpacing: 3, direction: .vertical, size: size1, inset: UIEdgeInsets.init())
      collectionItems.dataSource = self
      collectionItems.delegate = self

   }

   //MARK:- Functions

   private func getAllPhotos() {
      showLoader()
      PHPhotoLibrary.requestAuthorization { (status) in
         switch status {
         case .authorized:
            print("Good to proceed")
            let fetchOptions = PHFetchOptions()
            self.allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            DispatchQueue.main.async {
               if let array = self.allPhotos, array.count > 0 {
                  self.collectionItems.isHidden = false
                  self.collectionItems.reloadData()
               } else {
                  self.collectionItems.isHidden = true
               }
               hideLoader()
            }
         case .denied, .restricted:
            print("Not allowed")
            self.collectionItems.isHidden = true
            hideLoader()
         case .notDetermined:
            print("Not determined yet")
            self.collectionItems.isHidden = true
            hideLoader()
         default:
            self.collectionItems.isHidden = true
            hideLoader()
         }
      }
   }

   private func getAllUrls(_ complition : @escaping (([URL])->())) {
      var arrURL = [URL]()
      showLoader()
      if self.selectedPhotos.count > 0 {
          if let array = allPhotos {
              for index in selectedPhotos {
                  array[index].getURL { (url) in
                      if let urlObjc = url {
                          arrURL.append(urlObjc)
                      }
                      if self.selectedPhotos.count == arrURL.count {
                          hideLoader()
                        complition(arrURL)
                      }
                  }
              }
          }
      }
   }
   //MARK:- Actions
   @IBAction private func btnNext() {
      if let controller = ViewController(id: "GenerateVideoVC") as? GenerateVideoVC {
         getAllUrls { (urls) in
            controller.arrImageUrl = urls
            pushVC(controller)
         }
      }
   }
}

extension GalleryVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      if let array = allPhotos {
         return array.count
      }
      return 0
   }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      if let array = allPhotos {
         if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath) as? HomeItemCell {
            if selectedPhotos.contains(indexPath.row) {
               cell.setGalleryData(array[indexPath.row], isSelected: true)
            } else {
               cell.setGalleryData(array[indexPath.row])
            }
            return cell
         }
      }
      return UICollectionViewCell()
   }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: (self.view.frame.width / 4) - 12 , height: (self.view.frame.width / 4) - 12)
   }
}
extension GalleryVC: UICollectionViewDelegate {

   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if selectedPhotos.contains(indexPath.row) {
         var index = -1
         for i in 0..<selectedPhotos.count {
            if selectedPhotos[i] == indexPath.row {
               index = i
            }
         }
         selectedPhotos.remove(at: index)
      } else {
         selectedPhotos.append(indexPath.row)
      }
      collectionView.reloadItems(at: [indexPath])
   }
}

extension UIImageView{
   func fetchImage(asset: PHAsset, contentMode: PHImageContentMode, targetSize: CGSize) {
      let options = PHImageRequestOptions()
      options.version = .original
      PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, _ in
         guard let image = image else { return }
         switch contentMode {
         case .aspectFill:
            self.contentMode = .scaleAspectFill
         case .aspectFit:
            self.contentMode = .scaleAspectFit
         default:
            break
         }
         self.image = image
      }
   }
}
