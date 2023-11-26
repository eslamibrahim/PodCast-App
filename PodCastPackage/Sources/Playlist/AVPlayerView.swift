//
//  File.swift
//
//
//  Created by islam Awaad on 26/11/2023.
//

import Foundation
import SwiftUI
import AVFoundation
import AVKit
import UIKit

class PlayerViewController: UIViewController {
    private let videoURL: URL?
    private var player: AVPlayer?
    private var playerViewController: AVPlayerViewController?
    private var playerItemBufferEmptyObserver: NSKeyValueObservation?
    private var playerItemBufferKeepUpObserver: NSKeyValueObservation?
    private var playerItemBufferFullObserver: NSKeyValueObservation?
    private var loadingIndicator: UIActivityIndicatorView!
    
    init(videoURL: URL?) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        observePlayerBuffering()
        setupLoadingIndicator()
        showLoadingIndicator()
    }
    
    private func setupPlayer() {
        guard let videoURL else {
            return
        }
        player = AVPlayer(url: videoURL)
        playerViewController = AVPlayerViewController()
        playerViewController?.player = player
        playerViewController?.view.frame = view.bounds
        addChild(playerViewController!)
        view.addSubview(playerViewController!.view)
        playerViewController?.didMove(toParent: self)
    }
    
    private func observePlayerBuffering() {
        playerItemBufferEmptyObserver = player?.currentItem?.observe(\AVPlayerItem.isPlaybackBufferEmpty, options: [.new]) { [weak self] (_, _) in
            guard let self = self else { return }
            print("Loading")
           self.showLoadingIndicator()
        }
            
        playerItemBufferKeepUpObserver = player?.currentItem?.observe(\AVPlayerItem.isPlaybackLikelyToKeepUp, options: [.new]) { [weak self] (_, _) in
            guard let self = self else { return }
            print("play")
            self.hideLoadingIndicator()
        }
            
        playerItemBufferFullObserver = player?.currentItem?.observe(\AVPlayerItem.isPlaybackBufferFull, options: [.new]) { [weak self] (_, _) in
            guard let self = self else { return }
            print("play")
            self.hideLoadingIndicator()
        }
    }
    
    func invalidateObserver() {
        playerItemBufferEmptyObserver?.invalidate()
        playerItemBufferEmptyObserver = nil
            
        playerItemBufferKeepUpObserver?.invalidate()
        playerItemBufferKeepUpObserver = nil
            
        playerItemBufferFullObserver?.invalidate()
        playerItemBufferFullObserver = nil
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.pause()
        invalidateObserver()
    }
    
    
    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .white
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
        
        // Center the loading indicator in the view
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func showLoadingIndicator() {
        // Start animating the loading indicator
        loadingIndicator.startAnimating()
        
        // Enable user interaction
        view.isUserInteractionEnabled = false
    }
    
    private func hideLoadingIndicator() {
        // Stop animating the loading indicator
        loadingIndicator.stopAnimating()
        
        // Disable user interaction
        view.isUserInteractionEnabled = true
    }
}


struct AVPlayerView: UIViewControllerRepresentable {

    var videoURL: URL?

    func updateUIViewController(_ playerController: PlayerViewController, context: Context) {
    }

    func makeUIViewController(context: Context) -> PlayerViewController {
        return PlayerViewController(videoURL: videoURL)
    }
}
