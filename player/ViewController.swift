//
//  ViewController.swift
//  player
//
//  Created by Olena on 15.03.2020.
//  Copyright © 2020 Elena Draguzya. All rights reserved.
//

import UIKit
import AVKit
import SafariServices

struct Constants {
    
    struct Urls {
//        static let streamUrl = URL(string: "https://img3.1sell.com.ua/V/Image/Blog/Picture/9/Radio_24_04_2017.m3u")!
        static let streamUrl = URL(string: "http://radio.mfm.ua/online128.m3u")!
        static let siteUrl = URL(string: "https://mfm.ua")!
    }
    struct Images {
        static let images = ["background1", "background2", "background3", "background4", "background5"]
    }
}

class MyPlayer: AVPlayer {
    class func create(url: URL) -> MyPlayer? {
        let asset = AVAsset(url: Constants.Urls.streamUrl)
        let playerItem = AVPlayerItem(asset: asset)
        let player = MyPlayer(playerItem: playerItem)
                
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
        print("Playback OK")
        try? AVAudioSession.sharedInstance().setActive(true)
        print("Session is Active")
        return player
    }
}

protocol PlayerState {
    func onPlayButton(vc: ViewController, player: AVPlayer, playBtn: UIButton)
}

class PauseState: PlayerState {
    func onPlayButton(vc: ViewController, player: AVPlayer, playBtn: UIButton) {
        player.play()
        playBtn.setImage(UIImage(named:"pause.png"),for:UIControl.State.normal)
        vc.state = PlayState()
    }
}

class  PlayState: PlayerState {
    func onPlayButton(vc: ViewController, player: AVPlayer, playBtn: UIButton) {
        player.pause()
        playBtn.setImage(UIImage(named:"play.png"),for:UIControl.State.normal)
        vc.state = PauseState()
    }
}


class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var swipeImageView: UIImageView!
    
    var player = MyPlayer.create(url: Constants.Urls.streamUrl) ?? AVPlayer()
    
    var state: PlayerState = PauseState()
    
    var image = Constants.Images.images
    var currentImage = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            self.view.addGestureRecognizer(swipeLeft)
        }

    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                if currentImage == 0 {
                    currentImage = image.count - 1
                } else {
                    currentImage -= 1
                }
                swipeImageView.image = UIImage(named: image[currentImage]);                          print("Swiped right")
            case UISwipeGestureRecognizer.Direction.left:
                if currentImage == image.count - 1 {
                    currentImage = 0
                } else {
                    currentImage += 1
                }
                swipeImageView.image = UIImage(named: image[currentImage]);                        print("Swiped left")
            default:
                break
            }
        }
    }
    

    @IBAction func playButton(_ sender: UIButton) {
        self.state.onPlayButton(vc: self, player: self.player, playBtn: sender)
    }
    
    @IBAction func siteButton(_ sender: Any) {
        let url = Constants.Urls.siteUrl
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}
