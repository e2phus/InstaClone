//
//  UploadPostController.swift
//  InStaCloneSnapKit
//
//  Created by e2phus on 2022/12/22.
//

import UIKit
import Firebase
import SnapKit

protocol UploadPostControllerDelegate: AnyObject {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
}

class UploadPostController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: UploadPostControllerDelegate?
    
    var user: User?
    var currentUser: User?
    var selectedImage: UIImage? {
        didSet {
            photoImageView.image = selectedImage
        }
    }
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var captionTextView: InputTextView = {
        let textView = InputTextView()
        textView.placeholderText = "Enter caption.."
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        textView.placeholderShouldCenter = false
        return textView
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/100"
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }
    
    // MARK: - API
    
    // MARK: - Actions
    @objc func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapDone() {
        print(#function)
        print("Share Post Here")
        
        guard let image = selectedImage else { return }
        print(image)
        guard let caption = captionTextView.text else { return }
        print(caption)
        guard let user = currentUser else { return }
        print(user)
        
        showLoader(true)
        
        PostService().uploadPost(caption: caption, image: image, user: user) { error in
            if let error = error {
                self.showLoader(false)
                print("Failed to upload post with error \(error.localizedDescription)")
                return
            }
            print("UploadSuccess")
            self.delegate?.controllerDidFinishUploadingPost(self)
        }
    }
    
    // MARK: - Helpers
    func checkMaxLength(_ textView: UITextView) {
        if (textView.text.count) > 100 {
            textView.deleteBackward()
        }
    }
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Upload Post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTapDone))
    }
    
    func configureLayout() {
        // PhotoImageView
        view.addSubview(photoImageView)
        photoImageView.layer.cornerRadius = 10
        photoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(180)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
        }
        
        // CaptionTextView
        view.addSubview(captionTextView)
        captionTextView.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(16)
            make.left.equalTo(view.snp.left).offset(12)
            make.right.equalTo(view.snp.right).offset(12)
            make.height.equalTo(64)
        }
        
        // CharacterCountLabel
        view.addSubview(characterCountLabel)
        characterCountLabel.snp.makeConstraints { make in
            make.bottom.equalTo(captionTextView.snp.bottom).offset(8)
            make.right.equalTo(view.snp.right).offset(-12)
            
        }
    }
}

// MARK: - UITextViewDelegate
extension UploadPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        let count = textView.text.count
        characterCountLabel.text = "\(count)/100"
    }
}
