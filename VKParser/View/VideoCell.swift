//
//  VideoCell.swift
//  VKParser
//
//  Created by Admin on 14.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import AVFoundation
import VK_ios_sdk
import WebKit

class VideoCell: UITableViewCell, WKUIDelegate {
    
    var videoID = ""
    var videoOwnerID = ""
    var accessKey = VKSdk.accessToken().accessToken
    
    lazy var webKit: WKWebView = {
        let webKit = WKWebView()
        webKit.translatesAutoresizingMaskIntoConstraints = false
        webKit.uiDelegate = self
        webKit.isHidden = true
        
        return webKit
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    let attachedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var playButton: UIButton = {
        let play = UIButton(type: .system)
        play.setImage(UIImage(named: "playIcon"), for: .normal)
        play.translatesAutoresizingMaskIntoConstraints = false
        play.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        return play
    }()
    
    private var videoURLString = ""
    
    private func getVideoUrl() {
        let paramsString = "\(videoOwnerID)_\(videoID)"
        let params = ["videos": paramsString]
        print(params)
        let request = VKRequest(method: "video.get", parameters: params)
        request?.execute(resultBlock: { (response) in
            var responseDict = (response?.json as AnyObject)["items"] as! [NSDictionary]
            print(response)
            //let files = responseDict[0]["files"] as! NSDictionary
            //self.videoURLString = self.getURLFromFiles(fromDictionary: files)
            self.videoURLString = responseDict[0]["player"] as! String
            print(self.videoURLString)
        }, errorBlock: { (error) in
            print(error)
        })
    }
    
    private func getURLFromFiles(fromDictionary dict: NSDictionary) -> String{
        let sizes = ["mp4_1080", "mp4_720", "mp4_480", "mp4_360"]
        for size in sizes {
            if let videoURL = dict[size] {
                return videoURL as! String
            }
        }
        return dict["mp4_240"] as! String
    }
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    @objc func handlePlay() {
        getVideoUrl()
        print("videoURL: \(videoURLString)")
        if let videoURL = URL(string: videoURLString) {
            /*player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = attachedImageView.bounds
            attachedImageView.layer.addSublayer(playerLayer!)
            player?.play()
            activityIndicatorView.startAnimating()
            playButton.isHidden = true*/
            playButton.isHidden = true
            attachedImageView.isHidden = true
            webKit.isHidden = false
            let request = URLRequest(url: videoURL)
            webKit.load(request)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        addSubview(attachedImageView)
        addSubview(playButton)
        addSubview(activityIndicatorView)
        addSubview(webKit)
        
        setupAttachedImageView()
        setupPlayButton()
        setupActivityIndicatorView()
        setupWebKit()
    }
    
    func setupWebKit() {
        webKit.centerXAnchor.constraint(equalTo: attachedImageView.centerXAnchor).isActive = true
        webKit.centerYAnchor.constraint(equalTo: attachedImageView.centerYAnchor).isActive = true
        webKit.widthAnchor.constraint(equalTo: attachedImageView.widthAnchor).isActive = true
        webKit.heightAnchor.constraint(equalTo: attachedImageView.heightAnchor).isActive = true
    }
    
    func setupPlayButton() {
        playButton.centerXAnchor.constraint(equalTo: attachedImageView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: attachedImageView.centerYAnchor).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func setupAttachedImageView() {
        attachedImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        attachedImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        attachedImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        attachedImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
    func setupActivityIndicatorView() {
        activityIndicatorView.centerXAnchor.constraint(equalTo: attachedImageView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: attachedImageView.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
