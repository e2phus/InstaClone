//
//  InputTextView.swift
//  InStaCloneSnapKit
//
//  Created by e2phus on 2022/12/22.
//

import UIKit

class InputTextView: UITextView {
    
    // MARK: - Properties
    var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
        }
    }
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    
    var placeholderShouldCenter = true {
        didSet {
            if placeholderShouldCenter {
                addSubview(placeholderLabel)
                placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
                placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
                placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
                placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            } else {
                addSubview(placeholderLabel)
                placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
                placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
                placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
            }
        }
    }
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func handleTextDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
