//
//  EditProfileHeader.swift
//  InStaCloneSnapKit
//
//  Created by blake on 2023/02/06.
//

import UIKit

protocol EditProfileHeaderDelegate: AnyObject {
    func didTapChangeProfilePhoto()
}

class EditProfileHeader: UIView {
    
    // MARK: - Properties
    private let user: User
    weak var delegate: EditProfileHeaderDelegate?
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2.0
        return imageView
    }()
    
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Profile Photo", for: .normal)
        button.addTarget(self, action: #selector(handleChangeProfilePhoto), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        configureUI()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func handleChangeProfilePhoto() {
        delegate?.didTapChangeProfilePhoto()
    }
    
    // MARK: - Helpers
    func configureUI() {
        backgroundColor = .systemGray6
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.centerY.equalTo(snp.centerY).offset(16)
            $0.centerX.equalTo(snp.centerX)
        }
        profileImageView.layer.cornerRadius = 100 / 2
        
        addSubview(changePhotoButton)
        changePhotoButton.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
        }
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl))
    }

}

