//
//  FilterViewModel.swift
//  PhotosEditer
//
//  Created by 200OK-IOS1 on 26/02/2019.
//  Copyright © 2020 2BSolution. All rights reserved.
//

import Foundation
import UIKit

class FilterImageModel {
   var orignalImage = UIImage()
   var filterName = "Default"
   var filterImage = UIImage()

   init(orignal: UIImage) {
      self.orignalImage = orignal
      self.filterImage = orignal
   }

   init(orignal: UIImage, filter: String) {
      self.orignalImage = orignal
      self.filterImage = orignal
      self.filterName = filter
   }
}
class FilterViewModel: NSObject {

   var arrFilterNames = [FilterImageModel]()
   var arrImagesList = [FilterImageModel]()

   var filter:CIFilter?
   let context = CIContext()

   override init() {
      super.init()
      arrFilterNames = [
         FilterImageModel.init(orignal: UIImage(named: "Default")!, filter: "Default"),
         FilterImageModel.init(orignal: UIImage(named: "CILinearToSRGBToneCurve")!, filter: "CILinearToSRGBToneCurve"),
         FilterImageModel.init(orignal: UIImage(named: "CISRGBToneCurveToLinear")!, filter: "CISRGBToneCurveToLinear"),
         FilterImageModel.init(orignal: UIImage(named: "CIColorInvert")!, filter: "CIColorInvert"),
         FilterImageModel.init(orignal: UIImage(named: "CIColorMonochrome")!, filter: "CIColorMonochrome"),
         FilterImageModel.init(orignal: UIImage(named: "CIColorPosterize")!, filter: "CIColorPosterize"),
         FilterImageModel.init(orignal: UIImage(named: "CIFalseColor")!, filter: "CIFalseColor"),
         FilterImageModel.init(orignal: UIImage(named: "CIMaskToAlpha")!, filter: "CIMaskToAlpha"),
         FilterImageModel.init(orignal: UIImage(named: "CIMaximumComponent")!, filter: "CIMaximumComponent"),
         FilterImageModel.init(orignal: UIImage(named: "CIMinimumComponent")!, filter: "CIMinimumComponent"),
         FilterImageModel.init(orignal: UIImage(named: "CIPhotoEffectChrome")!, filter: "CIPhotoEffectChrome"),
         FilterImageModel.init(orignal: UIImage(named: "CIPhotoEffectFade")!, filter: "CIPhotoEffectFade"),
         FilterImageModel.init(orignal: UIImage(named: "CIPhotoEffectInstant")!, filter: "CIPhotoEffectInstant"),
         FilterImageModel.init(orignal: UIImage(named: "CIPhotoEffectProcess")!, filter: "CIPhotoEffectProcess"),
         FilterImageModel.init(orignal: UIImage(named: "CIPhotoEffectTonal")!, filter: "CIPhotoEffectTonal"),
         FilterImageModel.init(orignal: UIImage(named: "CIPhotoEffectTransfer")!, filter: "CIPhotoEffectTransfer"),
         FilterImageModel.init(orignal: UIImage(named: "CISepiaTone")!, filter: "CISepiaTone"),
         FilterImageModel.init(orignal: UIImage(named: "CIVignette")!, filter: "CIVignette"),
         FilterImageModel.init(orignal: UIImage(named: "CICMYKHalftone")!, filter: "CICMYKHalftone"),
         FilterImageModel.init(orignal: UIImage(named: "CIDotScreen")!, filter: "CIDotScreen"),
         FilterImageModel.init(orignal: UIImage(named: "CIHatchedScreen")!, filter: "CIHatchedScreen"),
         FilterImageModel.init(orignal: UIImage(named: "CILineScreen")!, filter: "CILineScreen"),
         FilterImageModel.init(orignal: UIImage(named: "CIComicEffect")!, filter: "CIComicEffect"),
         FilterImageModel.init(orignal: UIImage(named: "CICrystallize")!, filter: "CICrystallize"),
         FilterImageModel.init(orignal: UIImage(named: "CIEdgeWork")!, filter: "CIEdgeWork"),
         FilterImageModel.init(orignal: UIImage(named: "CIHexagonalPixellate")!, filter: "CIHexagonalPixellate"),
         FilterImageModel.init(orignal: UIImage(named: "CIDiscBlur")!, filter: "CIDiscBlur"),
         FilterImageModel.init(orignal: UIImage(named: "CIZoomBlur")!, filter: "CIZoomBlur"),
      ]
   }

   func getFilteredOutput(cameraImg: CIImage) -> UIImage{
      
      if let _ = filter{
         filter!.setValue(cameraImg, forKey: kCIInputImageKey)
         let cgImage = self.context.createCGImage(filter!.outputImage!, from: cameraImg.extent)!
         return UIImage(cgImage: cgImage)
      }else{
         return UIImage(ciImage: cameraImg)
      }

   }

   func updateFilter(object: FilterImageModel)-> UIImage{
      print("\n------\n\(object.filterName)\n-------\n")
      if !object.filterName.elementsEqual("Default"),
         let filter = CIFilter(name: object.filterName),
         let ciImage = CIImage(image: object.orignalImage){
         showLoader()
         filter.setValue(ciImage, forKey: kCIInputImageKey)
         let cgImage = self.context.createCGImage(filter.outputImage!, from: ciImage.extent)!
         hideLoader()
         return UIImage(cgImage: cgImage)
      }else{
         return object.orignalImage
      }
   }
}
