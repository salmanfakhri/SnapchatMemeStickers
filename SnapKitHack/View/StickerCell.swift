//
//  StickerCell.swift
//  SnapKitHack
//
//  Created by Salman Fakhri on 3/10/19.
//  Copyright © 2019 Salman Fakhri. All rights reserved.
//

import UIKit

class StickerCell: UITableViewCell {
    
    static let reuseIdentifier = "stickerCell"
    static let cellHeight: CGFloat = 340
    
    let stickerImage: UIImageView = {
       return UIImageView()
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    private func setUpImageView() {
        stickerImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stickerImage)
        stickerImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        stickerImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stickerImage.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stickerImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        stickerImage.contentMode = .scaleAspectFit
        imageView?.backgroundColor = .red
    }
    
    func setUpCell(meme: RedditResponse.RedditResponseData.Child, image: UIImage) {
        if let url = URL(string: meme.data.url) {
            //downloadImage(from: url)
            stickerImage.image = image
        }
    }

    
}
