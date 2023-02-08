//
//  NotificationCell.swift
//  InStaCloneSnapKit
//
//  Created by e2phus on 2022/12/29.
//

import UIKit
import SnapKit

protocol NotificationCellDelegate: AnyObject {
    func cell(_ cell: NotificationCell, wantsToFollow uid: String)
    func cell(_ cell: NotificationCell, wantsToUnfollow uid: String)
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String)
}

class NotificationCell: UITableViewCell {
    
    // MARK: - Properties
    weak var delegate: NotificationCellDelegate?
    
    var viewModel: NotificationViewModel? {
        didSet {
            configure()
        }
    }
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    private lazy var followButton: UIButton = {
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
        guard let postId = viewModel?.notification.postId else { return }
        delegate?.cell(self, wantsToViewPost: postId)
    }
    
    @objc func handleFollowTapped() {
        guard let viewModel = viewModel else { return }
        
        if viewModel.notification.userIsFollowed {
            delegate?.cell(self, wantsToUnfollow: viewModel.notification.uid)
        } else {
            delegate?.cell(self, wantsToFollow: viewModel.notification.uid)
        }
    }
    
    // MARK: - Helpers
    func configureLayout() {
        // ProfileImageView
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.centerY.equalTo(snp.centerY)
            $0.left.equalTo(snp.left).offset(12)
            $0.width.height.equalTo(48)
        }
        profileImageView.layer.cornerRadius = 48 / 2
        
        contentView.addSubview(followButton)
        followButton.snp.makeConstraints {
            $0.centerY.equalTo(snp.centerY)
            $0.right.equalTo(snp.right).offset(-12)
            $0.width.equalTo(88)
            $0.height.equalTo(32)
        }
        
        contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.left.equalTo(profileImageView.snp.right).offset(8)
            $0.right.equalTo(followButton.snp.left).offset(-4)
        }
        
        contentView.addSubview(postImageView)
        postImageView.snp.makeConstraints { 
            $0.centerY.equalTo(snp.centerY)
            $0.right.equalTo(snp.right).offset(-12)
            $0.width.height.equalTo(40)
        }
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        postImageView.sd_setImage(with: viewModel.postImageUrl)
        
        infoLabel.attributedText = viewModel.notificationMessage
        
        followButton.isHidden = !viewModel.shouldHidePostImage
        postImageView.isHidden = viewModel.shouldHidePostImage
        
        followButton.setTitle(viewModel.followButtonText, for: .normal)
        followButton.backgroundColor = viewModel.followButtonBackgroundColor
        followButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
    }
}
