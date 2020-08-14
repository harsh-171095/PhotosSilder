//
//  GenerateVideoVC.swift
//  PhotosEditer
//
//  Created by 200OK-IOS1 on 26/02/2019.
//  Copyright © 2020 2BSolution. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SlideShowMaker

class GenerateVideoVC: UIViewController {

   @IBOutlet weak private var btnPlayPaush: UIButton!
   @IBOutlet weak private var viewVideo: UIView!
   //MARK:- Variable Declaration
   var arrImageUrl = [URL]()
   private var avPlayer: AVPlayer?
   private var avPlayerLayer: AVPlayerLayer?
   private var videoPlayerItem: AVPlayerItem? = nil {
      didSet {
         avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
      }
   }
   private var strVideoURL = ""
   private var strAudioURL = ""
   private var arrUIImage = [UIImage]()

   //MARK:- ViewController Lifecycle
   override func viewDidLoad() {
      super.viewDidLoad()
      setTheme()
      // Do any additional setup after loading the view.
   }

   private func setTheme() {
      btnPlayPaush.setImage(UIImage.init(named: "play"), for: .normal)
      btnPlayPaush.setImage(UIImage.init(named: "pause"), for: .selected)
      btnPlayPaush.layer.cornerRadius = btnPlayPaush.frame.height / 2
      btnPlayPaush.isHidden = true

      arrUIImage = []
      arrImageUrl.forEach { (urlImageObjc) in
         if let imgDataObjc = UIImage().getImage(fromLocal: urlImageObjc.absoluteString) {
            arrUIImage.append(imgDataObjc)
         }
      }
      showLoader()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
         self.setupMoviePlayer()
         self.makeVideo()
      })

   }


   //MARK:- Functions
   private func makeVideo() {
      let images = arrUIImage

      var audio: AVURLAsset?
      var timeRange: CMTimeRange?
      if let audioURL = URL.init(string: strAudioURL) {
         audio = AVURLAsset(url: audioURL)
         let audioDuration = CMTime(seconds: (Double(arrUIImage.count) * 1.3), preferredTimescale: audio!.duration.timescale)
         timeRange = CMTimeRange(start: CMTime.zero, duration: audioDuration)
      }

      // OR: VideoMaker(images: images, movement: ImageMovement.fade)
      let maker = VideoMaker(images: images, transition: ImageTransition.wipeMixed)

      maker.contentMode = .scaleAspectFit
      maker.transition = .crossFade
//      maker.movement = .fade
//      maker.movementFade = .upRight

      maker.exportVideo(audio: audio, audioTimeRange: timeRange, completed: { success, videoURL in
         hideLoader()
         if let url = videoURL {
            print(url)  // /Library/Mov/merge.mov
            self.strVideoURL = url.absoluteString
            self.videoPlayerItem = AVPlayerItem.init(url: url)
            self.btnPlayPaush.isHidden = false
         }
      }).progress = { progress in
         hideLoader()
         print(progress)
      }
   }

   private func setupMoviePlayer(){
      self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
      avPlayerLayer = AVPlayerLayer(player: avPlayer)

      avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
      avPlayer?.volume = 3
      avPlayer?.actionAtItemEnd = .none
      avPlayerLayer?.frame = viewVideo.bounds

      //self.backgroundColor = .clear
      self.viewVideo.layer.insertSublayer(avPlayerLayer!, at: 0)
      //      self.viewVideo.backgroundColor = .red
      NotificationCenter.default.addObserver(self,
                                             selector: #selector(self.playerItemDidReachEnd(notification:)),
                                             name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                             object: avPlayer?.currentItem)
      self.viewVideo.contentMode = .scaleAspectFit
   }

   func startVideo(){
      self.avPlayer?.play()
   }
   func stopVideo() {
      self.avPlayer?.pause()
   }

   //MARK:- Actions

   @IBAction private func btnBack_click() {
      popVC()
   }
   @IBAction private func btnPlayPaush_click() {
      if btnPlayPaush.isSelected {
         btnPlayPaush.isSelected = false
         stopVideo()
      } else {
         btnPlayPaush.isSelected = true
         startVideo()
      }
   }
   @IBAction private func btnFilter_click() {
      if let controller = ViewController(id: "FilterVC") as? FilterVC {
         controller.arrImages = arrUIImage
         pushVC(controller)
      }
   }
   @IBAction private func btnMusic_click() {
      if let controller = ViewController(id: "MusicVC") as? MusicVC {
         pushVC(controller)
      }
   }

   @objc private func playerItemDidReachEnd(notification: Notification) {
      let p: AVPlayerItem = notification.object as! AVPlayerItem
      p.seek(to: CMTime.zero, completionHandler: nil)
      btnPlayPaush_click()
   }
}
