//
//  ViewController.swift
//  SpacePhoto
//
//  Created by wickedRun on 2021/09/02.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var copyrightLabel: UILabel!
    
    let photoInfoController = PhotoInfoController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.isHidden = true // scrollview 가림.
        title = ""
        imageView.image = UIImage(systemName: "photo.on.rectangle")
        descriptionLabel.text = ""
        copyrightLabel.text = ""
        
        activityIndicator.isHidden = false // 보이게함.
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating() // fetch할때 시작하게함.
        // 아래 멈추고 가리고 scrollview보이게하는 라인을 중복되지 않게 바꿔야한다.
        // 지금은 시간이 없어서 그냥 넘어가겠다.
        // 함수를 만들어서 쓴다면 start만 떨이지게 되므로 기능적으로 애매해지기에 일단 이렇게 냅둔다.
        // activityIndicator.stopAnimating() 이 함수는
        // hidesWhenStopped 변수가 true라면 위에 함수를 호출했을때 자동으로 숨겨주기 때문에
        // 밑에 세줄에서 숨겨주는 라인은 주석처리
        photoInfoController.fetchPhotoInfo { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let photoInfo) :
                    self.updateUI(with: photoInfo)
                case .failure(let error) :
                    self.updateUI(with: error)
                    // photoInfo를 못가져올때 indicator 멈추고 가리고, scrollview 보이게함.
                    self.activityIndicator.stopAnimating()
//                    self.activityIndicator.isHidden = true
                    self.scrollView.isHidden = false
                }
            }
        }
    }
    
    func updateUI(with photoInfo: PhotoInfo) {
        if photoInfo.mediaType == "image" {
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
                    // url로 이미지를 가져오든 못가져오든 indicator를 멈추고 가리고, scrollview를 보이게함.
                    self.activityIndicator.stopAnimating()
//                    self.activityIndicator.isHidden = true
                    self.scrollView.isHidden = false
                }
            }
        } else if photoInfo.mediaType == "video" {
            title = photoInfo.title
            imageView.image = UIImage(systemName: "video.circle")
            descriptionLabel.text = "Today is video, Not image. \n" + photoInfo.description
            copyrightLabel.text = photoInfo.copyright
            UIApplication.shared.open(photoInfo.url, options: [:]) // 사파리로 링크열기.
            // video일때 indicator를 멈추고 가리고, scrollview를 보이게함.
            activityIndicator.stopAnimating()
//            activityIndicator.isHidden = true
            scrollView.isHidden = false
        }
    }
    
    func updateUI(with error: Error) {
        title = "Error Fetching Photo"
        imageView.image = UIImage(systemName: "exclamationmark.octagon")
        descriptionLabel.text = error.localizedDescription
        copyrightLabel.text = ""
    }

}

