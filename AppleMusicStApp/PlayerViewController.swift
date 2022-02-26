//
//  PlayerViewController.swift
//  AppleMusicStApp
//
//  Created by chxhyxn on 2022/02/26.
//

import UIKit
import AVFoundation
import Foundation

class PlayerViewController: UIViewController {

    @IBOutlet weak var imgViewThumbnail: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblArtist: UILabel!
    @IBOutlet weak var sliderPlaying: UISlider!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblTotalDuration: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    
    let simplePlayer = SimplePlayer.shared
    var isSeeking: Bool = false
    var timeObserver: Any?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateBtnPlay()
        updateTintColor()
        
        timeObserver = simplePlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 10), queue: DispatchQueue.main, using: {
            self.updateTime(time: $0)
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        updateTackInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        simplePlayer.pause()
        simplePlayer.replaceCurrentItem(with: nil)
    }
    
    @IBAction func toggleBtnPlay(_ sender: UIButton) {
        if simplePlayer.isPlaying{
            simplePlayer.pause()
        }else{
            simplePlayer.play()
        }
        updateBtnPlay()
    }
    
    @IBAction func dragBegin(_ sender: Any) {
        isSeeking = true
    }
    
    @IBAction func dragEnd(_ sender: Any) {
        isSeeking = false
    }
    
    @IBAction func seek(_ sender: UISlider) {
        guard let currentItem = simplePlayer.currentItem else {return}
        let position = Double(sender.value)
        let seconds = position * currentItem.duration.seconds
        let time = CMTime(seconds: seconds, preferredTimescale: 100)
        simplePlayer.seek(to: time)
    }
    
}

extension PlayerViewController {
    func updateTackInfo() {
        guard let track = simplePlayer.currentItem?.convertToTrack() else {
            return
        }
        imgViewThumbnail.image = track.artwork
        lblTitle.text = track.title
        lblArtist.text = track.artist
    }
    
    func updateBtnPlay(){
        let configuration = UIImage.SymbolConfiguration(pointSize: 40)
        let image : UIImage?
        if simplePlayer.isPlaying{
            image = UIImage(systemName: "pause.fill", withConfiguration: configuration)!
        } else {
            image = UIImage(systemName: "play.fill", withConfiguration: configuration)!
        }
        btnPlay.setImage(image, for: .normal)
    }
    
    func updateTime(time: CMTime) {
        lblCurrentTime.text = secondsToString(second: simplePlayer.currentTime)
        lblTotalDuration.text = secondsToString(second: simplePlayer.totalDuration)
        
        if isSeeking == false {
            sliderPlaying.value = Float(simplePlayer.currentTime/simplePlayer.totalDuration)
        }
    }
    
    func secondsToString(second: Double) -> String {
        guard second.isNaN == false else {
            return "0:00"
        }
        let secondInt = Int(second)
        let min = secondInt / 60
        let sec = secondInt % 60
        return "\(min):\(sec)"
    }
    
    func updateTintColor() {
        btnPlay.tintColor = DefaultStyle.Colors.tint
        sliderPlaying.tintColor = DefaultStyle.Colors.tint
    }
}
