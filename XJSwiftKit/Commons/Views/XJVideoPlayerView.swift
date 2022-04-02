//
//  XJVideoPlayerView.swift
//  ShiJianYun
//
//  Created by Mr.Yang on 2021/10/25.
//

import UIKit
import AVFoundation
import AVKit

class XJVideoPlayerView: UIImageView {
    
    /// 播放器
    var player: ZFPlayerController!
    
    /// 播放数组
    var assetURLs: [String] = []
    var assetURL: String = String()
    
    /// 控制层
    lazy var controlView: ZFPlayerControlView = {
        let control = ZFPlayerControlView()
        control.fastViewAnimated = true
        control.autoHiddenTimeInterval = 5
        control.autoFadeTimeInterval = 0.5
        control.prepareShowLoading = true
        control.prepareShowControlView = false
        return control
    }()
    
    /// 播放多个视频
    convenience init(frame: CGRect, assetURLs: [String]) {
        self.init(frame: frame)
        self.assetURLs = assetURLs
        
        self.setupPlayer()
    }
    
    /// 播放单个视频
    convenience init(frame: CGRect, assetURL: String) {
        self.init(frame: frame)
        self.assetURL = assetURL
        
        self.setupPlayer()
    }
 
    /// 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.isUserInteractionEnabled = true
        self.setImage(url: "", placeholder: "")
        
        self.addObservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.removeObservers()
    }
}

// MARK: - Player
extension XJVideoPlayerView {
    /// 加载播放器
    func setupPlayer() {
        
        /// 播放器管理类
        let playerManager = ZFAVPlayerManager()
        playerManager.shouldAutoPlay = true
        
        /// 初始化播放器
        self.player = ZFPlayerController(playerManager: playerManager, containerView: self)
        
        /// 设置控制层
        self.player.controlView = self.controlView
        
        /// 设置退到后台继续播放
        self.player.pauseWhenAppResignActive = false
        
        /// 横竖屏切换
        self.player.orientationWillChange = { player, isFullScreen in
            print("isFullScreen = \(isFullScreen)")
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate?.orientation = isFullScreen ? .allButUpsideDown : .portrait
        }
        
        /// 播放结束
        self.player.playerDidToEnd = { [weak self] asset in
            guard let self = self else { return }
            
            // 暂停播放
            self.player.stop()
        }
        
        /// 设置播放源
        if self.assetURLs.count > 0 {
            var URLs = [URL]()
            for assetURL in self.assetURLs {
                if let URL = NSURL(string: assetURL) as URL? {
                    URLs.append(URL)
                }
            }
            self.player.assetURLs = URLs
            self.player.playTheIndex(0)
            self.controlView.showTitle("", cover: UIImage(named: "icon_launchImage_top"), fullScreenMode: .landscape)
        } else {
            if let URL = NSURL(string: self.assetURL) as URL? {
                self.player.assetURL = URL
                self.controlView.showTitle("", cover: UIImage(named: "icon_launchImage_top"), fullScreenMode: .landscape)
            }
        }
    }
    
    /// 切换播放地址
    /// - Parameter url: 播放地址
    func changeToPlay(url: String) {
        if let URL = NSURL(string: url) as URL? {
            self.player.assetURL = URL
            self.controlView.showTitle("", cover: UIImage(named: "icon_launchImage_top"), fullScreenMode: .landscape)
        }
    }
    
    /// 暂停播放
    func pausePlay() {
        self.player.currentPlayerManager.pause()
    }
    
    /// 开始播放
    func startPlay() {
        self.player.currentPlayerManager.play()
    }
    
    /// 停止播放
    func stopPlay() {
        self.player.currentPlayerManager.stop()
    }
    
    /// 跳转到指定时间播放
    func seekToTime(seekTime: TimeInterval,
                    completeHandle: @escaping (Bool) -> ()) {
        self.player.seek(toTime: seekTime) { (isFinish) in
            completeHandle(isFinish)
        }
    }
    
    /// 设置静音
    func setMuted(mute: Bool) {
        if self.player.isMuted != mute {
            self.player.isMuted = mute
        }
    }
    
    /// 画中画 4.0.2
    func pipToPlay() {
        guard let _ = self.player.currentPlayerManager as? ZFAVPlayerManager else { return }
        //AVPictureInPictureController(playerLayer: manager.avPlayerLayer)
    }
}

// MARK: - Observer
extension XJVideoPlayerView {
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(avaudioSessionInterrupt(notification:)), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 被打断
    @objc func avaudioSessionInterrupt(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let info = userInfo["AVAudioSessionInterruptionTypeKey"] as? UInt else { return }
        let interruptionType = AVAudioSession.InterruptionType.init(rawValue: info)
        if interruptionType == .began {
            print("AVAudioSessionInterruptionType.began")
            self.pausePlay()
        }
        if interruptionType == .ended {
            print("AVAudioSessionInterruptionType.ended")
            self.startPlay()
        }
    }
}
