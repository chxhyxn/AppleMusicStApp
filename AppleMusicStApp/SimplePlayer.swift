//
//  SimplePlayer.swift
//  AppleMusicStApp
//
//  Created by chxhyxn on 2022/02/26.
//

import UIKit
import AVFoundation

class SimplePlayer {
    static let shared = SimplePlayer()
    
    private let player = AVPlayer()
    
    init() {}
    
    var currentItem: AVPlayerItem? {
        return player.currentItem
    }
    
    var currentTime: Double {
        return player.currentItem?.currentTime().seconds ?? 0
    }
    
    var totalDuration: Double {
        return player.currentItem?.duration.seconds ?? 0
    }
    
    var isPlaying: Bool {
        return player.isPlaying
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func seek(to time:CMTime) {
        player.seek(to: time)
    }
    
    func replaceCurrentItem(with item: AVPlayerItem?) {
        player.replaceCurrentItem(with: item)
    }
    
    func addPeriodicTimeObserver(forInterval: CMTime, queue: DispatchQueue?, using: @escaping (CMTime) -> Void) {
        player.addPeriodicTimeObserver(forInterval: forInterval, queue: queue, using: using)
    }
}
