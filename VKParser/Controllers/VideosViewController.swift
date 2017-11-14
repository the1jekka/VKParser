//
//  VideosViewController.swift
//  VKParser
//
//  Created by Admin on 14.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class VideosViewController: UITableViewController {
    
    var videos = [VideoAttachment]()
    private let cellID = "cellID"

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Videos Attachment"
        tableView.register(VideoCell.self, forCellReuseIdentifier: cellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return videos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! VideoCell
        
        let imageURL = videos[indexPath.row].photoURL
        cell.attachedImageView.loadImageUsingCacheWithUrl(urlString: imageURL)
        cell.videoID = String(videos[indexPath.row].id)
        cell.videoOwnerID = String(videos[indexPath.row].ownerID)
        //cell.accessKey = videos[indexPath.row].accessKey
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /*let url = videos[indexPath.item].photoURL
        let someImageView = UIImageView()
        someImageView.loadImageUsingCacheWithUrl(urlString: url)
        return someImageView.image!.size.height / someImageView.image!.size.width * tableView.bounds.width*/
        return 250
    }

}
