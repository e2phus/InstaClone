//
//  FeedCell.swift
//  InStaCloneSnapKit
//
//  Created by e2phus on 2022/12/21.
//

import UIKit
import SnapKit
import ActiveLabel
import SDWebImage

protocol FeedCellDelegate: AnyObject {
    func cell(_ cell: FeedCell, didLike post: Post)
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post)
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String)
    func cell(_ cell: FeedCell, wantsToViewLikesFor postId: String)
    func cell(_ cell: FeedCell, wantsToShowOptionsForPost post: Post)
    // func cell(_ cell: FeedCell, wantsToBookmarkForPost post: Post)
}

class FeedCell: UICollectionViewCell {
    
    // MARK: - Properties
    weak var delegate: FeedCellDelegate?
    var viewModel: PostViewModel? {
        didSet {
            configure()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showUserProfile))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        
        return imageView
    }()
    
    private lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(showUserProfile), for: .touchUpInside)
        return button
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
        return button
    }()
        
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "message"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapComments), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        return button
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapBookmark), for: .touchUpInside)
        return button
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLikesTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        
        return label
    }()
    
    // ActiveLabel
    let captionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let postTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "2 hours ago"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func showUserProfile() {
        print(#function)
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, wantsToShowProfileFor: viewModel.post.ownerUid)
    }
    
    @objc func showOptions() {
        print(#function)
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, wantsToShowOptionsForPost: viewModel.post)
    }
    
    @objc func didTapComments() {
        print(#function)
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, wantsToShowCommentsFor: viewModel.post)
    }
    
    @objc func didTapLike() {
        print(#function)
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, didLike: viewModel.post)
    }

    @objc func didTapShare() {
        print(#function)
    }
    
    @objc func didTapBookmark() {
        print(#function)
    }
    
    @objc func handleLikesTapped() {
        print(#function)
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, wantsToViewLikesFor: viewModel.post.postId)
    }
    
    // MARK: - Helpers
    func configureUI() {
        // ProfileImageView
        addSubview(profileImageView)
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.left.equalTo(12)
        }
        
        // UsernameButton
        addSubview(usernameButton)
        usernameButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(8)
        }
        
        // OptionsButton
        addSubview(optionsButton)
        optionsButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.right.equalTo(snp.right).offset(-12)
        }
        
        // PostImageView
        addSubview(postImageView)
        postImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.width.height.equalTo(snp.width).multipliedBy(1)
        }
        
        // StackView(likeButton, commentButton, shareButton)
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom)
            make.left.equalTo(postImageView.snp.left)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
        // BookmarkButton
        addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints { make in
            make.centerY.equalTo(stackView)
            make.right.equalTo(snp.right).offset(-8)
        }
        
        // LikesLabel
        addSubview(likesLabel)
        likesLabel.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(-4)
            make.left.equalTo(snp.left).offset(8)
        }
        
        // CaptionLabel
        addSubview(captionLabel)
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(likesLabel.snp.bottom).offset(8)
            make.left.equalTo(snp.left).offset(8)
        }
        
        // PostTimeLabel
        addSubview(postTimeLabel)
        postTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(captionLabel.snp.bottom).offset(8)
            make.left.equalTo(snp.left).offset(8)
        }
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        captionLabel.configureLinkAttribute = viewModel.configureLinkAttribute
        captionLabel.enabledTypes = viewModel.enabledTypes
        viewModel.customizeLabel(captionLabel)
        
        postImageView.sd_setImage(with: viewModel.imageUrl)
        profileImageView.sd_setImage(with: viewModel.userProfileImageUrl)
        usernameButton.setTitle(viewModel.username, for: .normal)
        
        likesLabel.text = viewModel.likesLabelText
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        
        postTimeLabel.text = viewModel.timestampString
    }
}
