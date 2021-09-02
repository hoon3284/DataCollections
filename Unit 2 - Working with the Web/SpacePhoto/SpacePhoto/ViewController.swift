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
                    // UI 변경은 main queue에서 작업해야함. 그래서 위에 DispatchQueue.main으로 감싸줬음.
                    self.title = photoInfo.title
                    self.descriptionLabel.text = photoInfo.description
                    self.copyrightLabel.text = photoInfo.copyright
                case .failure(let error) :
                    self.title = "Error Fetching Photo"
                    self.imageView.image = UIImage(systemName: "exclamationmark.octagon")
                    self.descriptionLabel.text = error.localizedDescription
                    self.copyrightLabel.text = ""
                }
            }
        }
    }


}

