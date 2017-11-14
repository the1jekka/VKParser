//
//  ImagesViewController.swift
//  VKParser
//
//  Created by Admin on 14.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ImagesViewController: UITableViewController {
    
    private let cellID = "cellID"
    var images = [ImageAttachment]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Images attachment"
        tableView.backgroundColor = .white
        tableView.register(ImageCell.self, forCellReuseIdentifier: cellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return images.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ImageCell

        let image = images[indexPath.row]
        
        cell.attachedImageView.loadImageUsingCacheWithUrl(urlString: image.photoURL)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = images[indexPath.item]
        let height = CGFloat(image.height) / CGFloat(image.width) * tableView.bounds.width
        
        return height
    }

}
