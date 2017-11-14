//
//  AudiosViewController.swift
//  VKParser
//
//  Created by Admin on 14.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class AudiosViewController: UITableViewController {
    
    var audios = [AudioAttachment]()
    private let cellID = "cellID"

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Audios attachment"
        tableView.register(AudioCell.self, forCellReuseIdentifier: cellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return audios.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AudioCell

        let audio = audios[indexPath.row]
        let songInfo = "\(audio.artist) - \(audio.title)"
        print(songInfo)
        cell.songInfoTextView.text = songInfo
        cell.durationTextView.text = String(audio.duration)
        cell.audioURLString = audio.url

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
