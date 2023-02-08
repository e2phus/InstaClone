//
//  ProfileHeader.swift
//  InStaCloneSnapKit
//
//  Created by e2phus on 2022/12/21.
//

import UIKit
import SnapKit
import SDWebImage

protocol ProfileHeaderDelegate: AnyObject {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User)
    func header(_ profileHeader: ProfileHeader, wantsToViewFollowersFor user: User)
    func header(_ profileHeader: ProfileHeader, wantsToViewFollowingFor user: User)
//    func headerWantsToshowEditProfile(_ profileHeader: ProfileHeader)
}

class ProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
    var viewModel: ProfileHeaderViewModel? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var postsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        // label.attributedText = attributedStatText(value: 5, label: "posts")
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        // label.attributedText = attributedStatText(value: 2, label: "followers")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        // label.attributedText = attributedStatText(value: 1, label: "following")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        
        return label
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.grid.3x3"), for: .normal)
        return button
    }()
    
    let tagButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.fill.viewfinder"), for: .normal)
        return button
    }()
    
    let topDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let bottomDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func handleEditProfileFollowTapped() {
        print(#function)
        guard let viewModel = viewModel else { return }
        delegate?.header(self, didTapActionButtonFor: viewModel.user)
    }
    
    @objc func handleFollowersTapped() {
        print(#function)
    }
    
    @objc func handleFollowingTapped() {
        print(#function)
    }
    
    // MARK: - Helpers
    func configureLayout() {
        // ProfileImageView
        addSubview(profileImageView)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(16)
            make.left.equalTo(snp.left).offset(12)
            make.width.height.equalTo(80)
        }
        
        // NameLabel
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.left.equalTo(snp.left).offset(8)
        }
        
        // EditProfileButton
        addSubview(editProfileFollowButton)
        editProfileFollowButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.left.equalTo(snp.left).offset(24)
            make.right.equalTo(snp.right).offset(-24)
        }
        
        // InfoStackView
        let infoStackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        infoStackView.distribution = .fillEqually
        addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.centerY.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(12)
            make.right.equalTo(snp.right).offset(-12)
        }
        
        // PostStackView
        let postStackView = UIStackView(arrangedSubviews: [gridButton, tagButton])
        postStackView.distribution = .fillEqually
        addSubview(postStackView)
        postStackView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
    
        // TopDivider
        addSubview(topDivider)
        topDivider.snp.makeConstraints { make in
            make.top.equalTo(postStackView.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        // BottomDivider
        addSubview(bottomDivider)
        bottomDivider.snp.makeConstraints { make in
            make.top.equalTo(postStackView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        print(#function)
        print("Did call configure function in ProfileHeader")
    
        nameLabel.text = viewModel.username
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        
        editProfileFollowButton.setTitle(viewModel.followButtonText, for: .normal)
        editProfileFollowButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
        editProfileFollowButton.backgroundColor = viewModel.followButtonBackgroundColor
        
        postsLabel.attributedText = viewModel.numberOfPosts
        followersLabel.attributedText = viewModel.numberOfFollowers
        followingLabel.attributedText = viewModel.numberOfFollowing
    }
}

