//
//  EditProfileCell.swift
//  InStaCloneSnapKit
//
//  Created by blake on 2023/02/06.
//

import UIKit

protocol EditProfileCellDelegate: AnyObject {
    func updateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell: UITableViewCell {
    
    // MARK: - Properties
    var viewModel: EditProfileViewModel? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: EditProfileCellDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var infoTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .left
        textField.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        return textField
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func handleUpdateUserInfo() {
        delegate?.updateUserInfo(self)
    }
    
    // MARK: - Helpers
    func configureUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.top.equalTo(snp.top).offset(12)
            $0.left.equalTo(snp.left).offset(16)
        }
        
        contentView.addSubview(infoTextField)
        infoTextField.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(4)
            $0.left.equalTo(titleLabel.snp.right).offset(16)
            $0.right.equalTo(snp.right).offset(-8)
        }
   
    }
    func configure() {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.titleText
        
        infoTextField.text = viewModel.optionValue
    }
}

