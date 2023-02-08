//
//  ChatCell.swift
//  InStaCloneSnapKit
//
//  Created by blake on 2023/02/06.
//

import UIKit
import Firebase

class MessageCell: UICollectionViewCell {
    
    // MARK: - Properties
    var viewModel: MessageViewModel? {
        didSet {
            configure()
        }
    }
    
    var bubbleLeftAnchor: NSLayoutConstraint!
    var bubbleRightAnchor: NSLayoutConstraint!
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 15)
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let bubbleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        return view
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func configureUI() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.left.equalTo(snp.left).offset(8)
            $0.bottom.equalTo(snp.bottom).offset(4)
            $0.width.height.equalTo(32)
        }
        profileImageView.layer.cornerRadius = 32 / 2
        
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        bubbleContainer.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.lessThanOrEqualTo(250)
        }
        
        bubbleLeftAnchor = bubbleContainer.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12)
        bubbleLeftAnchor.isActive = true
        
        bubbleRightAnchor = bubbleContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        bubbleRightAnchor.isActive = true
        
        bubbleContainer.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalTo(bubbleContainer.snp.top).offset(4)
            $0.left.equalTo(bubbleContainer.snp.left).offset(12)
            $0.bottom.equalTo(bubbleContainer.snp.bottom).offset(4)
            $0.right.equalTo(bubbleContainer.snp.right).offset(-12)
        }
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        bubbleContainer.layer.borderWidth = viewModel.messageBorderWidth
        bubbleContainer.layer.borderColor = UIColor.lightGray.cgColor
        textView.text = viewModel.messageText
        
        bubbleLeftAnchor.isActive = viewModel.leftAnchorActive
        bubbleRightAnchor.isActive = viewModel.rightAnchorActive
        
        profileImageView.isHidden = viewModel.shouldHideProfileImage
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
}
