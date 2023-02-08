//
//  ProfileCell.swift
//  InStaCloneSnapKit
//
//  Created by e2phus on 2022/12/21.
//

import UIKit
import SnapKit

class ProfileCell: UICollectionViewCell {
    
    // MARK: - Properties
    var viewModel: PostViewModel? {
        didSet {
            configure()
        }
    }
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "tortoise")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    
    // MARK: - Helpers
    func configureLayout() {
        addSubview(postImageView)
        postImageView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
        
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        postImageView.sd_setImage(with: viewModel.imageUrl)
    }
}
