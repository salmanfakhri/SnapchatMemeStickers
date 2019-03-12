//
//  StickerPickerViewController.swift
//  SnapKitHack
//
//  Created by Salman Fakhri on 3/10/19.
//  Copyright © 2019 Salman Fakhri. All rights reserved.
//

import UIKit


protocol StickerPickerDelegate {
    func didSelectSticker(image: UIImage)
}

class StickerPickerViewController: UIViewController {
    
    let tableView: UITableView = {
       return UITableView()
    }()
    
    var loadingIcon = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var delegate: StickerPickerDelegate?
    
    var stickers: [RedditResponse.RedditResponseData.Child] = []
    var stickerImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Wholesome Memes"
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setUpTableView()
        tableView.isHidden = true
        getMemes()
        loadingIcon.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        view.addSubview(loadingIcon)
        loadingIcon.center = view.center
//        loadingIcon.startAnimating()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func getMemes() {
        loadingIcon.isHidden = false
        loadingIcon.startAnimating()
        if (stickers.count == 0) {
            APIService.shared().getMemes { (memes) in
                self.stickers = memes
                for meme in memes {
                    guard let url = URL(string: meme.data.url) else { return }
                    self.downloadImage(from: url)
                }
            }
        }
    }
    
    func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 63).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.register(StickerCell.self, forCellReuseIdentifier: StickerCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 600
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        //print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            //print("Download Finished")
            self.stickerImages.append(UIImage(data: data)!)
            DispatchQueue.main.async {
                print("\(self.stickers.count) \(self.stickerImages.count)")
                if (self.stickerImages.count == self.stickers.count) {
                    self.tableView.isHidden = false
                    self.loadingIcon.isHidden = true
                    self.loadingIcon.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        }
    }

}

extension StickerPickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stickers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StickerCell.reuseIdentifier, for: indexPath) as? StickerCell else { return UITableViewCell() }
        cell.setUpCell(meme: stickers[indexPath.row], image: stickerImages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StickerCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectSticker(image: stickerImages[indexPath.row])
        
        navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
}
