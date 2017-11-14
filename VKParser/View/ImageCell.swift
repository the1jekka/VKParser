//
//  ImageCellTableViewCell.swift
//  VKParser
//
//  Created by Admin on 13.11.2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    let attachedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        addSubview(attachedImageView)
        
        setupAttachedImageView()
    }
    
    func setupAttachedImageView() {
        attachedImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        attachedImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        attachedImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        attachedImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
