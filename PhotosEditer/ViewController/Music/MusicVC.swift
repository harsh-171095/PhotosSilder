//
//  MusicVC.swift
//  PhotosEditer
//
//  Created by 200OK-IOS1 on 26/02/2019.
//  Copyright © 2020 2BSolution. All rights reserved.
//

import UIKit

class MusicVC: UIViewController {

   @IBOutlet weak private var tblMusic: UITableView!
   @IBOutlet weak private var viewControllers: UIView!
   @IBOutlet weak private var lblMusicTitle: UILabel!
   @IBOutlet weak private var progressMusic: UIProgressView!

   //MARK:- Variable Declaration
   private let cell = "MusicCell"
   var arrImages = [UIImage]()
   private var selectedIndex = 0
   private let vmObject = FilterViewModel()
   private var arrMusicUrls = [URL]()
   private var intSelected = 0
   //MARK:- Variable Declaration
   override func viewDidLoad() {
      super.viewDidLoad()
      setTheme()
   }

   private func setTheme() {
      tblMusic.setTheme(cell: cell)
      tblMusic.dataSource = self
      tblMusic.delegate = self

      /*let mediaItems = MPMediaQuery.songs().items
      print(mediaItems)*/
      let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
      let url = URL(fileURLWithPath: documentsPath)

      let fileManager = FileManager.default
      let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: url.path)!
      while let element = enumerator.nextObject() as? String{
         if element.hasSuffix(".mp3") {
            // do something
            print(element)
            let newURL = url
            arrMusicUrls.append(newURL.appendingPathComponent(element))
         }
      }
      tblMusic.reloadData()
   }

   //MARK:- Actions
   @IBAction private func btnBack_click() {
      popVC()
   }

}
extension MusicVC: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return arrMusicUrls.count
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if let cell = tableView.dequeueReusableCell(withIdentifier: self.cell, for: indexPath) as? MusicCell {
         cell.setData(title: arrMusicUrls[indexPath.row], isPlay: indexPath.row == intSelected)
      }
      return UITableViewCell()
   }

}
extension MusicVC: UITableViewDelegate {

   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 55
   }
}
