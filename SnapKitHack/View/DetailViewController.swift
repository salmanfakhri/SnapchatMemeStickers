//
//  DetailViewController.swift
//  SnapKitHack
//
//  Created by Salman Fakhri on 3/10/19.
//  Copyright © 2019 Salman Fakhri. All rights reserved.
//

import UIKit
import Photos
import SCSDKCreativeKit

class DetailViewController: UIViewController {
    
    let previewImageView: UIImageView = {
        return UIImageView()
    }()
    
    let containerView: UIView = {
       return UIView()
    }()
    
    let closeButton: UIButton = {
       return UIButton()
    }()
    
    let addImageButton: UIButton = {
        return UIButton(type: .system)
    }()
    
    let createSnapButton: UIButton = {
        return UIButton(type: .system)
    }()
    
    let pickerVC: StickerPickerViewController = {
       return StickerPickerViewController()
    }()
    
    var stickerMoveGesture: UIPanGestureRecognizer?
    var removeStickerGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpContainerView()
        setUpPreviewImageView()
        setUpCloseButton()
        setUpAddImageButton()
        setUpCreateSnapButton()
        pickerVC.delegate = self
        setUpGestures()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    @objc func closePreview() {
        navigationController?.popViewController(animated: false)
    }
    
    func setUpContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setUpPreviewImageView() {
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(previewImageView)
        previewImageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        previewImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        previewImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        previewImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        previewImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
    func setUpCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
        closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.backgroundColor = .white
        closeButton.setTitle("<", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.layer.cornerRadius = 20
        closeButton.addTarget(self, action: #selector(closePreview), for: .touchUpInside)
    }
    
    func setUpAddImageButton() {
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addImageButton)
        addImageButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
        addImageButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        addImageButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        addImageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addImageButton.backgroundColor = .white
        addImageButton.setTitle("add sticker", for: .normal)
        addImageButton.setTitleColor(.black, for: .normal)
        addImageButton.layer.cornerRadius = 20
        addImageButton.addTarget(self, action: #selector(addStickerButton), for: .touchUpInside)
    }
    
    func setUpCreateSnapButton() {
        createSnapButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createSnapButton)
        createSnapButton.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 20).isActive = true
        createSnapButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        createSnapButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        createSnapButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        createSnapButton.backgroundColor = .white
        createSnapButton.setTitle("create snap", for: .normal)
        createSnapButton.setTitleColor(.black, for: .normal)
        createSnapButton.layer.cornerRadius = 20
        createSnapButton.addTarget(self, action: #selector(createSnap), for: .touchUpInside)
    }
    
    @objc func createSnap() {
        print("creating snap")
        //UIImageWriteToSavedPhotosAlbum(containerView.asImage(), nil, nil, nil)
        let snapPhoto = SCSDKSnapPhoto(image: containerView.asImage())
        let snap = SCSDKPhotoSnapContent(snapPhoto: snapPhoto)
        // snap.sticker = /* Optional, add a sticker to the Snap */
        // snap.caption = /* Optional, add a caption to the Snap */
        // snap.attachmentUrl = /* Optional, add a link to the Snap */
        let api = SCSDKSnapAPI(content: snap)
        api.startSnapping { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                // Successfully shared content to Snapchat!
                print("yay!!")
            }
        }
    }
    
    @objc func addStickerButton() {
        print("add sticker")
        navigationController?.pushViewController(pickerVC, animated: true)
    }
    
    func addImageToPreview(image: UIImage) {
        previewImageView.image = image
    }
    
    func addStickerToView(image: UIImage) {
        
        let resizedImage = resizeImage(image: image, newWidth: 230)
        let imageView = UIImageView(image: resizedImage)
        containerView.addSubview(imageView)
        imageView.center = view.center
        imageView.addGestureRecognizer(stickerMoveGesture!)
        imageView.addGestureRecognizer(removeStickerGesture!)
        imageView.isUserInteractionEnabled = true
        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func setUpGestures() {
        stickerMoveGesture = UIPanGestureRecognizer(target: self, action: #selector(didDragSticker(_:)))
        removeStickerGesture = UITapGestureRecognizer(target: self, action: #selector(removeSticker(_:)))
        removeStickerGesture?.numberOfTapsRequired = 2
        
    }
    
    @objc func didDragSticker(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let sticker = gesture.view!
        
        sticker.center = CGPoint(x: sticker.center.x + translation.x, y: sticker.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc func removeSticker(_ gesture: UITapGestureRecognizer) {
        let sticker = gesture.view!
        sticker.removeFromSuperview()
    }
}

extension DetailViewController: StickerPickerDelegate {
    func didSelectSticker(image: UIImage) {
        print("got sticker")
        addStickerToView(image: image)
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
