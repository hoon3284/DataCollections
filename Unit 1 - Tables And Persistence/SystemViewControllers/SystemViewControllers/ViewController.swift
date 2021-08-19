//
//  ViewController.swift
//  SystemViewControllers
//
//  Created by wickedRun on 2021/08/18.
//

import UIKit
import SafariServices
import MessageUI

class ViewController: UIViewController,
                      UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate,
                      MFMailComposeViewControllerDelegate
{

    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func safariButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "http://www.youtube.com") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func CameraButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        // actionSheet는 하단에 버튼들이 생기는 style. alert은 가운데에 뜨는 경고창.
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
            // 실제 앱에서 실행할 때 아래 error가 뜬다.
            //‘This app has crashed because it attempted to access privacy-sensitive data without a usage description. The app's Info.plist must contain an NSCameraUsageDescription key with a string value explaining to the user how the app uses this data.’
            // 에러 발생 이유로는 permission을 받지 못해서.
            // 해결 방법은 Info.plist에서 NSCameraUsageDescription 속성을 만든다. - 이 속성은 카메라 퍼미션을 왜 받는지에 대한 설명.
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        alertController.popoverPresentationController?.sourceView = sender
        
        present(alertController, animated: true, completion: nil)
    }
    
    // ImagePickerControllerDelegate method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 이미지를 선택하면 호출되는 메소드 인것 같음 그래서 선택한 이미지를 UIImage로 캐스팅하고 imageView.image를 선택한 이미지로 바꾸고 dismiss함.
        // 아래 .originalImage는 upcropped하고 사용자가 선택한 이미지.
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Can not send mail")
            return
        }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        
        mailComposer.setToRecipients(["hoon3284@icloud.com"])
        mailComposer.setSubject("Look at this")
        mailComposer.setMessageBody("Hello, this is an email from the app I made.", isHTML: false)
        
        if let image = imageView.image, let jpegData = image.jpegData(compressionQuality: 0.9) {
            mailComposer.addAttachmentData(jpegData, mimeType: "image/jpeg", fileName: "photo.jpg")
        }
        
        present(mailComposer, animated: true, completion: nil)
    }
    
    // MFMailComposeViewController delegate method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print(error ?? "no Err")
        dismiss(animated: true, completion: nil)
    }
}

