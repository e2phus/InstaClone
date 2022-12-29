//
//  NotificationCell.swift
//  InStaCloneSnapKit
//
//  Created by e2phus on 2022/12/29.
//

import UIKit
import SnapKit

class NotificationCell: UITableViewCell {
    
    // MARK: - Properties
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person")?.withRenderingMode(.alwaysOriginal)
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    private let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Actions
    @objc func handlePostTapped() {
        
    }
    
    
    @objc func handleFollowTapped() {
        
    }
    
    // MARK: - Helpers
    func configureLayout() {
        // ProfileImageView
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.left.equalTo(snp.left).offset(12)
            make.width.height.equalTo(48)
        }
        profileImageView.layer.cornerRadius = 48 / 24
        
        addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.left.equalTo(profileImageView.snp.right).offset(8)
        }
        
        addSubview(followButton)
        followButton.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(snp.right).offset(-12)
            make.width.equalTo(100)
            make.height.equalTo(32)
        }
        
        addSubview(postImageView)
        postImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(snp.right).offset(-12)
            make.width.height.equalTo(40)
        }
        
        followButton.isHidden = true

    }
}
