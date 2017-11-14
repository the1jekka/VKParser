//
//  PostViewController.swift
//  VKParser
//
//  Created by Admin on 14.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class PostViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var post: Post? {
        didSet {
            navigationItem.title = "Wall Post"
            observePost()
        }
    }
    
    var senderAvatarURL = ""
    var senderName = ""
    var postItems = [PostItems]()
    
    private func observePost() {
        if let myPost = post?.myPost {
            postItems.append(myPost)
        }
        
        if let repost = post?.repost {
            postItems.append(repost)
        }
    }
    
    private let reuseIdentifier = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        self.collectionView!.register(PostCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        
        print(postItems.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return postItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCell
        
        let post = postItems[indexPath.row]
        getName(id: post.ownerID)
        cell.postSender.text = String(post.ownerID)
        let date = Date(timeIntervalSince1970: Double(post.date))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM HH:mm"
        cell.postSender.text = senderName
        if senderAvatarURL != "" {
            cell.senderAvatar.loadImageUsingCacheWithUrl(urlString: senderAvatarURL)
        }
        cell.postDate.text = dateFormatter.string(from: date)
        if let text = post.text {
            cell.postText.text = text
        } else {
            cell.postText.text = ""
        }
        
        
        cell.images = post.imageAttachment
        cell.videos = post.videoAttachment
        cell.audios = post.audioAttachment
        
        cell.videosButton.addTarget(self, action: #selector(handlePerformVideosController(_:)), for: .touchUpInside)
        cell.audiosButton.addTarget(self, action: #selector(handlePerformAudiosController(_:)), for: .touchUpInside)
        cell.imagesButton.addTarget(self, action: #selector(handlePerformImagesController(_:)), for: .touchUpInside)
    
        return cell
    }
    
    @objc func handlePerformImagesController(_ sender: ImageButton) {
        let imagesController = ImagesViewController()
        imagesController.images = sender.images
        navigationController?.pushViewController(imagesController, animated: true)
    }
    
    @objc func handlePerformAudiosController(_ sender: AudioButton) {
        let audiosController = AudiosViewController()
        audiosController.audios = sender.audios
        navigationController?.pushViewController(audiosController, animated: true)
    }
    
    @objc func handlePerformVideosController(_ sender: VideoButton) {
        let videosController = VideosViewController()
        videosController.videos = sender.videos
        navigationController?.pushViewController(videosController, animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
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
            self.senderName = "\(name) \(lastName)"
            self.senderAvatarURL = nameDict[0]["photo_medium"] as! String
        }, errorBlock: { (error) in
            print(error)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 150
        let post = postItems[indexPath.item]
        if let text = post.text {
            height = estimateFrameForText(text).height
        }
        if height <= 150 {
            height += 150
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    func estimateFrameForText(_ text: String) -> CGRect{
        let size = CGSize(width: UIScreen.main.bounds.width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }

}
