//
//  AudioCell.swift
//  VKParser
//
//  Created by Admin on 14.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import AVFoundation

class AudioCell: UITableViewCell {

    var audioURLString = ""
    
    let songInfoTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isSelectable = false
        textView.isEditable = false
        return textView
    }()
    
    let playView: UIButton = {
        let play = UIButton(type: .custom)
        play.setImage(UIImage(named: "playAudio"), for: .normal)
        play.isUserInteractionEnabled = true
        play.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        play.translatesAutoresizingMaskIntoConstraints = false
        
        return play
    }()
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    @objc func handlePlay() {
        if let audioURL = URL(string: audioURLString) {
            print(audioURL)
            player = AVPlayer(url: audioURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = self.bounds
            self.layer.addSublayer(playerLayer!)
            player?.play()
        }
    }
    
    let durationTextView: UITextView = {
        let duration = UITextView()
        duration.translatesAutoresizingMaskIntoConstraints = false
        duration.isEditable = false
        duration.isSelectable = false
        return duration
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        addSubview(songInfoTextView)
        addSubview(playView)
        addSubview(durationTextView)
        
        setupPlayView()
        setupDurationTextView()
        setupSongInfoView()
    }
    
    func setupPlayView() {
        playView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        playView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        playView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playView.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupSongInfoView() {
        songInfoTextView.leftAnchor.constraint(equalTo: playView.rightAnchor, constant: 8).isActive = true
        songInfoTextView.rightAnchor.constraint(equalTo: durationTextView.leftAnchor, constant: -8).isActive = true
        songInfoTextView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        songInfoTextView.heightAnchor.constraint(equalTo: playView.heightAnchor).isActive = true
    }
    
    func setupDurationTextView() {
        durationTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        durationTextView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        durationTextView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        durationTextView.heightAnchor.constraint(equalTo: playView.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
