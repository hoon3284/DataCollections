//
//  ViewController.swift
//  SpacePhoto
//
//  Created by wickedRun on 2021/09/02.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var copyrightLabel: UILabel!
    
    let photoInfoController = PhotoInfoController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        imageView.image = UIImage(systemName: "photo.on.rectangle")
        descriptionLabel.text = ""
        copyrightLabel.text = ""
        
        photoInfoController.fetchPhotoInfo { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let photoInfo) :
                    self.updateUI(with: photoInfo)
                case .failure(let error) :
                    self.updateUI(with: error)
                }
            }
        }
    }
    
    func updateUI(with photoInfo: PhotoInfo) {
        photoInfoController.fetchImage(from: photoInfo.url) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.title = photoInfo.title
                    self.imageView.image = image
                    self.descriptionLabel.text = photoInfo.description
                    self.copyrightLabel.text = photoInfo.copyright
                case .failure(let error):
                    self.updateUI(with: error)
                }
            }
        }
    }
    
    func updateUI(with error: Error) {
        title = "Error Fetching Photo"
        imageView.image = UIImage(systemName: "exclamationmark.octagon")
        descriptionLabel.text = error.localizedDescription
        copyrightLabel.text = ""
    }

}

