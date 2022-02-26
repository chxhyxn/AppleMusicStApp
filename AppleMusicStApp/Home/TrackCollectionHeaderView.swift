//
//  TrackCollectionHeaderView.swift
//  AppleMusicStApp
//
//  Created by chxhyxn on 2022/02/25.
//

import UIKit
import AVFoundation

class TrackCollectionHeaderView: UICollectionReusableView {
    @IBOutlet weak var imgViewThumbnail: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    
    var item: AVPlayerItem?
    var tapHandler: ((AVPlayerItem) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgViewThumbnail.layer.cornerRadius = 4
    }
    
    func update(with item: AVPlayerItem) {
        self.item = item
        guard let track = item.convertToTrack() else { return }
        
        self.imgViewThumbnail.image = track.artwork
        self.lblDescription.text = "\(track.artist) - \(track.title)"
    }
    
    @IBAction func btnFullFace(_ sender: UIButton) {
        guard let todaysItem = item else {return}
        tapHandler?(todaysItem)
    }
    
}
