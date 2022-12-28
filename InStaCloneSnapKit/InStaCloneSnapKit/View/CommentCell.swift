//
//  CommentCell.swift
//  InStaCloneSnapKit
//
//  Created by e2phus on 2022/12/22.
//

import UIKit
import SnapKit

class CommentCell: UICollectionViewCell {
    
    // MARK: - Properties
    var viewModel: CommentViewModel? {
        didSet {
            configure()
        }
    }
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        
        return imageView
    }()
    
    private let commentLabel = UILabel()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - API
    
    // MARK: - Helpers
    func configureLayout() {
        // ProfileImageView
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.left.equalTo(snp.left).offset(8)
            make.height.width.equalTo(40)
        }
        profileImageView.layer.cornerRadius = 40 / 2
        
        // CommentLabel
        commentLabel.numberOfLines = 0
        addSubview(commentLabel)
        commentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.right.equalTo(snp.right).offset(-8)
        }
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        commentLabel.attributedText = viewModel.commentLabelText()
    }
    
}
