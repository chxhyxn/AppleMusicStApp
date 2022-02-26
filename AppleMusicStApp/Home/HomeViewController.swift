//
//  HomeViewController.swift
//  AppleMusicStApp
//
//  Created by chxhyxn on 2022/02/24.
//

import UIKit

class HomeViewController: UIViewController {
    let trackManager: TrackManager = TrackManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
extension HomeViewController: UICollectionViewDataSource {
    // 몇개 표시 할까?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackManager.tracks.count
    }
    
    // 셀 어떻게 표시 할까?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackCollectionViewCell", for: indexPath) as? TrackCollecionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = trackManager.track(at: indexPath.item)
        cell.updateUI(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let item = trackManager.todaysTrack else {
                return UICollectionReusableView()
            }
        
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TrackCollectionHeaderView", for: indexPath) as? TrackCollectionHeaderView else {
                return UICollectionReusableView()
            }
            header.update(with: item)
            header.tapHandler = {
                let playerStoryboard = UIStoryboard.init(name: "Player", bundle: nil)
                guard let playerVC = playerStoryboard.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController else { return }
                playerVC.simplePlayer.replaceCurrentItem(with: $0)
                playerVC.currentTrackIndex = -1
                playerVC.trackManager = self.trackManager
                self.present(playerVC, animated: true, completion: nil)
            }
            
            return header
        default :
            return UICollectionReusableView()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playerStoryboard = UIStoryboard.init(name: "Player", bundle: nil)
        guard let playerVC = playerStoryboard.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController else { return }
        let item = trackManager.tracks[indexPath.item]
        playerVC.simplePlayer.replaceCurrentItem(with: item)
        playerVC.currentTrackIndex = indexPath.item
        playerVC.trackManager = trackManager
        present(playerVC, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    // 셀 사이즈 어떻게 할까?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 20
        let inset: CGFloat = 10
        let width: CGFloat = (collectionView.bounds.width - itemSpacing - inset * 2)/2
        let height: CGFloat = width + 40
        return CGSize(width: width, height: height)
    }
}
