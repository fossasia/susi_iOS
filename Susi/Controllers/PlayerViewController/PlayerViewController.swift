//
//  PlayerViewController.swift
//  Susi
//
//  Created by JOGENDRA on 16/07/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    // youtube player
    lazy var youtubePlayer: YouTubePlayerView = {
        let viewFrame = UIScreen.main.bounds
        let player = YouTubePlayerView(frame: CGRect(x: 0, y: 0, width: viewFrame.width - 16, height: viewFrame.height * 1/3))
        player.delegate = self
        return player
    }()

    // used as an overlay to dismiss the youtube player
    let blackView = UIView()

    // youtube player loader
    lazy var playerIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        indicator.hidesWhenStopped = true
        return indicator
    }()

    init(videoID: String) {
        super.init(nibName: nil, bundle: nil)
        addYotubePlayer()
        play(videoID)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(self.windowBecomeVisible), name: UIWindow.didBecomeVisibleNotification, object: self.view.window)
    }

    @objc func windowBecomeVisible() {
        if(youtubePlayer.isVideoPlayerStopped()) {
            handleDismiss()
        }
    }
    // shows youtube player
    func addYotubePlayer() {
        if let window = UIApplication.shared.keyWindow {
            blackView.frame = window.frame
            view.addSubview(blackView)
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
            tap.numberOfTapsRequired = 1
            tap.cancelsTouchesInView = false
            blackView.addGestureRecognizer(tap)

            let centerX = UIScreen.main.bounds.size.width / 2
            let centerY = UIScreen.main.bounds.size.height / 2

            blackView.addSubview(playerIndicator)
            playerIndicator.center = CGPoint(x: centerX, y: centerY)
            playerIndicator.startAnimating()

            blackView.addSubview(youtubePlayer)
            youtubePlayer.center = CGPoint(x: centerX, y: centerY)

            blackView.alpha = 0
            youtubePlayer.alpha = 0

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.youtubePlayer.alpha = 1
            }, completion: nil)
        }
    }

    func play(_ videoID: String) {
        youtubePlayer.loadVideoID(videoID)
    }

    @objc func handleDismiss() {
        blackView.removeFromSuperview()
        self.dismiss(animated: false, completion: nil)
    }

}

extension PlayerViewController: YouTubePlayerDelegate {

    func playerReady(_ videoPlayer: YouTubePlayerView) {
        self.playerIndicator.stopAnimating()
        videoPlayer.play()
    }

    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
    }

    func playerQualityChanged(_ videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
    }

}
