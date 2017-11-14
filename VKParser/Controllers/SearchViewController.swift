//
//  SearchViewController.swift
//  VKParser
//
//  Created by Admin on 10.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import VK_ios_sdk
import RealmSwift

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    var viewController: ViewController?
    
    let inputContatinerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
        return containerView
    }()
    
    lazy var userGroupSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["User", "Group"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = .white
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(handleUserGroupChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.delegate = self
        textField.placeholder = " Enter \(userGroupSegmentedControl.titleForSegment(at: userGroupSegmentedControl.selectedSegmentIndex)!) id..."
        return textField
    }()
    
    lazy var findPostsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Find posts", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleFindPosts), for: .touchUpInside)
        
        return button
    }()
    
    lazy var showMyPostsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Show my posts", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleShowMyPosts), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleShowMyPosts() {
        let params = ["owner_id": VKSdk.accessToken().userId, "count": 50] as [String : Any]
        let request = VKRequest.init(method: "wall.get", parameters: params)
        
        request?.execute(resultBlock: { (response) in
            let dictArray = (response?.json as AnyObject)["items"] as! [NSDictionary]
            let wall = self.getWall(posts: self.getPosts(json: dictArray))
            self.addDataToRealm(wall: wall)
            let resultsController = ResultsViewController()
            let navController = UINavigationController(rootViewController: resultsController)
            self.present(navController, animated: true, completion: nil)
        }, errorBlock: { (error) in
            print(error)
            return
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func getWall(posts: Array<Post>) -> Wall {
        let wall = Wall()
        wall.posts = posts
        return wall
    }
    
    private func getPosts(json dictArray: [NSDictionary]) -> Array<Post> {
        var posts = Array<Post>()
        
        for item in dictArray {
            let postItems = self.parseJSONResponse(json: item)
            var repostedPostItems: PostItems? = nil
            if let repostHistory = item["copy_history"] as? [NSDictionary] {
                repostedPostItems = self.parseJSONResponse(json: repostHistory[0])
            }
            let post = Post()
            post.myPost = postItems
            post.repost = repostedPostItems
            posts.append(post)
        }
        
        return posts
    }
    
    private func parseJSONResponse(json: NSDictionary) -> PostItems {
        let postItems = PostItems()
        postItems.postID = json["id"] as! Int
        postItems.ownerID = json["owner_id"] as! Int
        postItems.date = json["date"] as! Int
        postItems.text = nil
        let postText = json["text"] as! String
        if postText != "" {
            postItems.text = postText
        }
        var videos = Array<VideoAttachment>()
        var audios = Array<AudioAttachment>()
        var photos = Array<ImageAttachment>()
        if let attachments = json["attachments"] as? [NSDictionary] {
            
            for item in attachments {
                let attachmentType = item["type"] as! String
                let attachment = item[attachmentType] as! NSDictionary
                switch attachmentType {
                case "video":
                    let videoAttachment = parseVideoAttachment(attachment: attachment)
                    videos.append(videoAttachment)
                case "audio":
                    let audioAttachment = parseAudioAttachment(attachment: attachment)
                    audios.append(audioAttachment)
                case "photo":
                    let photoAttachment = parsePhotoAttachment(attachment: attachment)
                    photos.append(photoAttachment)
                default:
                    break
                }
            }
        }
        postItems.videoAttachment = videos
        postItems.audioAttachment = audios
        postItems.imageAttachment = photos
        if let canDelete = json["can_delete"] as? Int {
            if canDelete == 1 {
                postItems.canDelete = true
            } else {
                postItems.canDelete = false
            }
        }
        postItems.comments = parseComments(json: json)
        
        return postItems
    }
    
    func parseComments(json: NSDictionary) -> Comments? {
        if let jsonComments = json["comments"] as? NSDictionary {
            let comment = Comments()
            let canPost = jsonComments["can_post"] as! Int
            if canPost == 1 {
                comment.canPost = true
            } else {
                comment.canPost = false
            }
            comment.count = jsonComments["count"] as! Int
            if let groupsCanPost = jsonComments["groups_can_post"] as? String {
                if groupsCanPost == "true" {
                    comment.groupsCanPost = true
                } else {
                    comment.groupsCanPost = false
                }
            }
            
            return comment
        }
        return nil
    }
    
    func parsePhotoAttachment(attachment: NSDictionary) -> ImageAttachment {
        let id: Int = attachment["id"] as! Int
        let albumID: Int = attachment["album_id"] as! Int
        let ownerID: Int = attachment["owner_id"] as! Int
        let userID: Int = 100
        let photoURL: String = getPhotoURL(attachment: attachment)
        let width: Int = attachment["width"] as! Int
        let height: Int = attachment["height"] as! Int
        let date: Int = attachment["date"] as! Int
        var accessKey: String? = nil
        if let imageAccessKey: String = attachment["access_key"] as? String {
            accessKey = imageAccessKey
        }
        
        return ImageAttachment(id: id, albumID: albumID, ownerID: ownerID, userID: userID, photoURL: photoURL, width: width, height: height, date: date, accessKey: accessKey)
    }
    
    func getPhotoURL(attachment: NSDictionary) -> String {
        let sizes = ["photo_2560", "photo_1280", "photo_807", "photo_604", "photo_130"]
        for photoSize in sizes {
            if let imageURL = attachment[photoSize] {
                return imageURL as! String
            }
        }
        
        return attachment["photo_75"] as! String
    }
    
    func parseAudioAttachment(attachment: NSDictionary) -> AudioAttachment {
        let id: Int = attachment["id"] as! Int
        let ownerID: Int = attachment["owner_id"] as! Int
        let artist: String = attachment["artist"] as! String
        let title: String = attachment["title"] as! String
        let duration: Int = attachment["duration"] as! Int
        let url: String = attachment["url"] as! String
        let date: Int = attachment["date"] as! Int
        
        return AudioAttachment(id: id, ownerID: ownerID, artist: artist, title: title, duration: duration, url: url, date: date)
    }
    
    func parseVideoAttachment(attachment: NSDictionary) -> VideoAttachment {
        let id: Int = attachment["id"] as! Int
        let ownerID: Int = attachment["owner_id"] as! Int
        var title: String = attachment["title"] as! String
        let videoDescription: String = attachment["description"] as! String
        let date: Int = attachment["date"] as! Int
        let views: Int = attachment["views"] as! Int
        let photoURL: String = getStartImageOfVideo(attachment: attachment)
        let accessKey: String = attachment["access_key"] as! String
        let duration = attachment["duration"] as! Int
        
        return VideoAttachment(id: id, ownerID: ownerID, title: title, videoDescription: videoDescription, date: date, views: views, photoURL: photoURL, accessKey: accessKey, duration: duration)
    }
    
    func getStartImageOfVideo(attachment: NSDictionary) -> String {
        let sizes = ["photo_800", "photo_640", "photo_320"]
        
        for imageSize in sizes {
            if let imageURL = attachment[imageSize] {
                return imageURL as! String
            }
        }
        
        return attachment["photo_130"] as! String
    }
    
    func handleFindPostsByUserID(){
        guard let inputText = inputTextField.text else {
            print("Enter user ID")
            return
        }
        let params = ["owner_id": inputText, "count": 50] as [String : Any]
        let request = VKRequest.init(method: "wall.get", parameters: params)
        
        request?.execute(resultBlock: { (response) in
            let dictArray = (response?.json as AnyObject)["items"] as! [NSDictionary]
            let wall = self.getWall(posts: self.getPosts(json: dictArray))
            self.addDataToRealm(wall: wall)
            let resultsController = ResultsViewController()
            let navController = UINavigationController(rootViewController: resultsController)
            self.present(navController, animated: true, completion: nil)
        }, errorBlock: { (error) in
            print(error)
            return
        })
    }
    
    func handleFindPostsByGroupID() {
        guard let inputText = inputTextField.text else {
            print("Enter group ID")
            return
        }
        let params = ["owner_id": "-\(inputText)", "count": 50] as [String : Any]
        let request = VKRequest.init(method: "wall.get", parameters: params)
        
        request?.execute(resultBlock: { (response) in
            let dictArray = (response?.json as AnyObject)["items"] as! [NSDictionary]
            let wall = self.getWall(posts: self.getPosts(json: dictArray))
            self.addDataToRealm(wall: wall)
            let resultsController = ResultsViewController()
            let navController = UINavigationController(rootViewController: resultsController)
            self.present(navController, animated: true, completion: nil)
        }, errorBlock: { (error) in
            print(error)
            return
        })
    }
    
    func addDataToRealm(wall: Wall) {
        let realmWall = wall.putDataToRealmModel()
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(realmWall)
        }
    }
    
    @objc func handleFindPosts() {
        if userGroupSegmentedControl.selectedSegmentIndex == 0 {
            handleFindPostsByUserID()
        } else {
            handleFindPostsByGroupID()
        }
    }

    @objc func handleUserGroupChanged() {
        let title = userGroupSegmentedControl.titleForSegment(at: userGroupSegmentedControl.selectedSegmentIndex)!
        inputTextField.placeholder = "Enter \(title) id..."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(userGroupSegmentedControl)
        view.addSubview(inputContatinerView)
        inputContatinerView.addSubview(inputTextField)
        view.addSubview(findPostsButton)
        view.addSubview(showMyPostsButton)
        
        setupUserGroupSegmentedControl()
        setupInputContainerView()
        setupInputTextField()
        setupFindPostsButton()
        setupShowMyPostsButton()
    }
    
    func setupShowMyPostsButton() {
        showMyPostsButton.topAnchor.constraint(equalTo: findPostsButton.bottomAnchor, constant: 8).isActive = true
        showMyPostsButton.leftAnchor.constraint(equalTo: inputContatinerView.leftAnchor).isActive = true
        showMyPostsButton.rightAnchor.constraint(equalTo: inputContatinerView.rightAnchor).isActive = true
        showMyPostsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupFindPostsButton() {
        findPostsButton.topAnchor.constraint(equalTo: inputContatinerView.bottomAnchor, constant: 8).isActive = true
        findPostsButton.leftAnchor.constraint(equalTo: inputContatinerView.leftAnchor).isActive = true
        findPostsButton.rightAnchor.constraint(equalTo: inputContatinerView.rightAnchor).isActive = true
        findPostsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func setupInputContainerView() {
        inputContatinerView.topAnchor.constraint(equalTo: userGroupSegmentedControl.bottomAnchor, constant: 8).isActive = true
        inputContatinerView.leftAnchor.constraint(equalTo: userGroupSegmentedControl.leftAnchor).isActive = true
        inputContatinerView.rightAnchor.constraint(equalTo: userGroupSegmentedControl.rightAnchor).isActive = true
        inputContatinerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupInputTextField() {
        inputTextField.topAnchor.constraint(equalTo: inputContatinerView.topAnchor, constant: 8).isActive = true
        inputTextField.leftAnchor.constraint(equalTo: inputContatinerView.leftAnchor, constant: 8).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: inputContatinerView.rightAnchor, constant: -8).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: inputContatinerView.bottomAnchor, constant: -8).isActive = true
    }
    
    func setupUserGroupSegmentedControl() {
        userGroupSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userGroupSegmentedControl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16).isActive = true
        userGroupSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        userGroupSegmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
    }
}
