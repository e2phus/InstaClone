//
//  CommentInputTextView.swift
//  InStaCloneSnapKit
//
//  Created by e2phus on 2022/12/23.
//

import UIKit

protocol CommentInputTextViewDelegate: AnyObject {
    func inputView(_ inputView: CommentInputTextView, wantsToUploadComment comment: String)
}

class CommentInputTextView: UIView {
    
    // MARK: - Properties
    weak var delegate: CommentInputTextViewDelegate?
    
    private let commentTextView: InputTextView = {
        let textView = InputTextView()
        textView.placeholderText = "Enter comment..."
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.isScrollEnabled = false
        textView.placeholderShouldCenter = true
        return textView
    }()
    
    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handlePostTapped), for: .touchUpInside)
        return button
    }()
    
    
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    
    // MARK: - API
    
    // MARK: - Actions
    @objc func handlePostTapped() {
        print(#function)
        delegate?.inputView(self, wantsToUploadComment: commentTextView.text)
    }
    
    // MARK: - Helpers
    func configureLayout() {
        // PostButton
        addSubview(postButton)
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        postButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 50).isActive = true

        // CommentTextView
        addSubview(commentTextView)
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        commentTextView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        commentTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        commentTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        commentTextView.trailingAnchor.constraint(equalTo: postButton.leadingAnchor, constant: -8).isActive = true
        
        // Divider
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
    }
    
    func clearCommentTextView() {
        commentTextView.text = nil
        commentTextView.placeholderLabel.isHidden = false
    }
}
