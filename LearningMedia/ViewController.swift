//
//  ViewController.swift
//  LearningMedia
//
//  Created by Tiến Việt Trịnh on 05/07/2023.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    //MARK: - Properties
    var player: AVPlayer!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .purple
        requestAuthorzation()

    }
    
    func requestAuthorzation() {
        MPMediaLibrary.requestAuthorization { status in
            switch status {
            case .notDetermined:
                DispatchQueue.main.async {
                    let url = URL(string:UIApplication.openSettingsURLString)!
                    UIApplication.shared.open(url)
                }
            case .denied:
                DispatchQueue.main.async {
                    let url = URL(string:UIApplication.openSettingsURLString)!
                    UIApplication.shared.open(url)
                }
            case .restricted:
                break
            case .authorized:
                self.queryData()
                self.setupRomoteCommander()
                self.setupRemoteComanderView()
            @unknown default:
                return
            }
        }
    }
    
    func queryData() {
        let query = MPMediaQuery()
        let aidoru = query.items!.first!
        let url = aidoru.assetURL!
        
        let playerItem = AVPlayerItem(url: url)
        print("DEBUG: \(url)")
        
        player = AVPlayer(playerItem: playerItem)
        player.play()
        player.rate = 2
    }
    
    func setupRomoteCommander() {
        let commander = MPRemoteCommandCenter.shared()
        
        commander.playCommand.addTarget { event in
            self.playMedia()
            return .success
        }
        
        commander.pauseCommand.addTarget { event in
            self.pauseMedia()
            return .success
        }
        
        commander.nextTrackCommand.addTarget { event in
            self.nextMedia()
            return .success
        }
        
        commander.previousTrackCommand.addTarget { event in
            self.previousMedia()
            return .success

        }
    }
    
    func setupRemoteComanderView() {
        guard let item = MPMediaQuery().items?.first else {return}
        var playingInfo = [String: Any]()
        playingInfo[MPMediaItemPropertyArtist] = item.title
        playingInfo[MPMediaItemPropertyArtist] = item.artist
        playingInfo[MPMediaItemPropertyAlbumTitle] = item.albumTitle
        playingInfo[MPMediaItemPropertyPlaybackDuration] = item.playbackDuration
        
        playingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize(width: 40, height: 40), requestHandler: { size in
            return UIImage(named: "bp")!
        })
        playingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(player.currentTime())
        playingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 2
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = playingInfo
        
    }
    
    func playMedia() {
        player.playImmediately(atRate: 1.5)

        guard let item = MPMediaQuery().items?.first else {return}
        var playingInfo = [String: Any]()
        playingInfo[MPMediaItemPropertyArtist] = item.title
        playingInfo[MPMediaItemPropertyArtist] = item.artist
        playingInfo[MPMediaItemPropertyAlbumTitle] = item.albumTitle
        playingInfo[MPMediaItemPropertyPlaybackDuration] = item.playbackDuration

        playingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize(width: 40, height: 40), requestHandler: { size in
            return UIImage(named: "bp")!
        })
        playingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(player.currentTime())
        playingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 2

        MPNowPlayingInfoCenter.default().nowPlayingInfo = playingInfo
    }
    
    func pauseMedia() {
        player.pause()
        guard let item = MPMediaQuery().items?.first else {return}
        var playingInfo = [String: Any]()
        playingInfo[MPMediaItemPropertyArtist] = item.title
        playingInfo[MPMediaItemPropertyArtist] = item.artist
        playingInfo[MPMediaItemPropertyAlbumTitle] = item.albumTitle
        playingInfo[MPMediaItemPropertyPlaybackDuration] = item.playbackDuration

        playingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize(width: 40, height: 40), requestHandler: { size in
            return UIImage(named: "bp")!
        })
        playingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(player.currentTime())
        playingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 0

        MPNowPlayingInfoCenter.default().nowPlayingInfo = playingInfo
    }
    
    func nextMedia() {
        
    }
    
    func previousMedia() {
        
    }
    //MARK: - Selectors
    
}
//MARK: - delegate
