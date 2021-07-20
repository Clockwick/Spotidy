//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Paratthakorn Sribunyong on 18/7/2564 BE.
//

import AVFoundation
import Foundation
import UIKit

protocol PlayerDataSource: AnyObject {
    var songName: String? {get}
    var subtitle: String? {get}
    var imageURL: URL? {get}
}

final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    
    var playerVC: PlayerViewController?
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    private var index = 0
    
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    
    var currentTrack: AudioTrack?  {
        if let track = track, tracks.isEmpty {
            return track
        }
        else if !tracks.isEmpty {
            return tracks[index]
        }
        return nil
    }
    
    func startPlayback(from viewController: UIViewController,
                              track: AudioTrack)
    {
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        player = AVPlayer(url: url)
        player?.volume = 0.5
        
        self.tracks = []
        self.track = track
        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.player?.play()
        }
        self.playerVC = vc
    }
    
    
    func startPlayback(from viewController: UIViewController,
                              tracks: [AudioTrack])
    {
        self.tracks = tracks
        self.track = nil
        
        self.playerQueue = AVQueuePlayer(items: tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? "") else {
                return nil
            }
            return AVPlayerItem(url: url)
        }))
        self.playerQueue?.volume = 0.5
        self.playerQueue?.play()
        
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true)
        self.playerVC = vc
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didTapPlayPauseButton() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
        else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func didTapPreviousButton() {
        if tracks.isEmpty {
            // Not playlist or album
            player?.pause()
            player?.play()
        }
        else if let firstItem = playerQueue?.items().first {
//            playerQueue?.pause()
//            playerQueue?.removeAllItems()
//            playerQueue? = AVQueuePlayer(items: [firstItem])
//            playerQueue?.play()
//            playerQueue?.volume = 0.5
            if index > 0 {
                index -= 1
                playerVC?.refreshUI()
            }
        }
    }
    
    func didTapNextButton() {
        if tracks.isEmpty {
            // Not playlist or album
            player?.pause()
        }
        else if let player = playerQueue {
            playerQueue?.advanceToNextItem()
            index += 1
            playerVC?.refreshUI()
        }
    }
    
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
    
    
}

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}
