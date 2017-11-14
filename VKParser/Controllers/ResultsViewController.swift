//
//  ResultsViewController.swift
//  VKParser
//
//  Created by Admin on 13.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import RealmSwift
import VK_ios_sdk

class ResultsViewController: UITableViewController {
    var wall: Wall?
    let cellID = "cellID"
    var senderName = ""
    var senderAvatarURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        wall = getWallFromRealm()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        let id = wall?.posts![0].myPost?.ownerID
        getName(id: id)
        tableView.register(PostsCell.self, forCellReuseIdentifier: cellID)
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (wall?.posts![indexPath.row].myPost?.canDelete)! {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let post = wall?.posts![indexPath.row]
        
        if (post?.myPost?.canDelete)! {
            let params = ["owner_id": post?.myPost?.ownerID, "post_id": post?.myPost?.postID]
            let request = VKRequest(method: "wall.delete", parameters: params)
            request?.execute(resultBlock: { (response) in
                self.wall?.posts!.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }, errorBlock: { (error) in
                print(error)
            })
        }
    }
    
    private func getName(id: Int?) {
        var id = id!
        if id < 0 {
            id *= -1
            getGroupName(groupID: id)
        } else {
            getUserName(userID: id)
        }
        
    }
    
    private func getGroupName(groupID: Int?) {
        let params = ["group_id": groupID]
        let request = VKRequest(method: "groups.getById", parameters: params)
        request?.execute(resultBlock: { (response) in
            let groupInfo = response?.json as! [NSDictionary]
            if self.navigationItem.title == nil {
                self.navigationItem.title = groupInfo[0]["name"] as! String
            }
            self.senderName = groupInfo[0]["name"] as! String
            self.senderAvatarURL = groupInfo[0]["photo_100"] as! String
        }, errorBlock: { (error) in
            print(error)
        })
    }
    
    private func getUserName(userID: Int?) {
        let params = ["user_ids" : userID, "fields": "photo_medium"] as [String : Any]
        let request = VKRequest(method: "users.get", parameters: params)
        var name = ""
        var lastName = ""
        request?.execute(resultBlock: { (response) in
            let nameDict = response?.json as! [NSDictionary]
            name = nameDict[0]["first_name"] as! String
            lastName = nameDict[0]["last_name"] as! String
            if self.navigationItem.title == nil {
                self.navigationItem.title = "\(name) \(lastName)"
            }
            self.senderName = "\(name) \(lastName)"
            self.senderAvatarURL = nameDict[0]["photo_medium"] as! String
            print(self.senderAvatarURL)
        }, errorBlock: { (error) in
            print(error)
        })
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func getWallFromRealm() -> Wall {
        let realm = try! Realm()
        let realmWall = realm.objects(RealmWall.self)
        
        return (realmWall.last?.putDataToModel())!
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
        return (wall?.posts?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PostsCell
        getName(id: wall?.posts![indexPath.row].myPost?.ownerID)
        if let postText = wall?.posts![indexPath.row].myPost?.text {
            cell.postTextLabel.text = postText
        } else {
            cell.postTextLabel.text = "Post without text. Tap to view post"
        }
        print("senderAvatar: \(senderAvatarURL)")
        let timeDate = Date(timeIntervalSince1970: Double((wall?.posts![indexPath.row].myPost?.date)!))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM HH:mm"
        cell.dateLabel.text = dateFormatter.string(from: timeDate)
        if senderAvatarURL != "" {
            cell.senderAvatar.loadImageUsingCacheWithUrl(urlString: senderAvatarURL)
        }
        cell.postSender.text = senderName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = wall?.posts![indexPath.item]
        var height: CGFloat = 100
        if let text = post?.myPost?.text {
            height = estimateForText(text).height + 20
            if height < 100 {
                height = 100
            }
        }
        
        return height
    }
    
    func estimateForText(_ text: String) -> CGRect{
        let size = CGSize(width: tableView.bounds.width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = wall?.posts![indexPath.row]
        showPostController(forPost: post!)
    }
    
    private func showPostController(forPost post: Post) {
        print("123")
        let postViewController = PostViewController(collectionViewLayout:  UICollectionViewFlowLayout())
        
        postViewController.post = post
        navigationController?.pushViewController(postViewController, animated: true)
    }

}
