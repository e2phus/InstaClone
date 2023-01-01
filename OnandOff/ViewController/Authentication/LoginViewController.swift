//
//  LoginViewController.swift
//  OnandOff
//
//  Created by SangWoo's MacBook on 2022/12/31.
//

import SnapKit
import UIKit

class LoginViewController: UIViewController {

    // MARK: - Properties
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Login")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "세상에 없던 멀티 자아 기록 플랫폼"
        label.numberOfLines = 3
        label.textColor = .white
        // Font 적용 ?
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "OnOff")
        return imageView
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.tintColor = .black
        button.setTitleColor(#colorLiteral(red: 0.3450980392, green: 0.7215686275, blue: 0.631372549, alpha: 1), for: .normal)
        button.backgroundColor = .white
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    // MARK: - Actions
    
    
    
    // MARK: - Helpers
    func configureUI() {
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(174)
            make.left.equalTo(view.snp.left).offset(42)
            make.width.equalTo(192)
            make.height.equalTo(180)
        }
        
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(459)
            make.left.equalTo(view.snp.left).offset(42)
            make.width.equalTo(189)
            make.height.equalTo(49)
        }
        
        view.addSubview(loginButton)
        // CornerRadius ??
        loginButton.layer.cornerRadius = 46
        loginButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(-40)
            make.width.equalTo(335)
            make.height.equalTo(54)
        }
    }
}

