//
//  ResetPasswordController.swift
//  InStaCloneSnapKit
//
//  Created by blake on 2023/02/03.
//

import UIKit

protocol ResetPasswordControllerDelegate: AnyObject {
    func controllerDidSendResetPasswordLink(_ controller: ResetPasswordController)
}

class ResetPasswordController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: ResetPasswordControllerDelegate?
    private let emailTextField = CusTomTextField(placeholder: "Email")
    private var viewModel = ResetPasswordViewModel()
    var email: String?

    private let iconImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset Password", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 0.7287221488).withAlphaComponent(0.3)
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Actions
    @objc func handleResetPassword() {
        guard let email = emailTextField.text else { return }
        AuthService.resetPassword(withEmail: email) { error in
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                self.showLoader(false)
                return
            }
        }
        
        self.delegate?.controllerDidSendResetPasswordLink(self)
        
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }
    
        updateForm()
    }
    
    @objc func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    private func configureUI() {
        configureGradientLayer()
        
        emailTextField.text = email
        viewModel.email = email
        updateForm()
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
            
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.left.equalTo(view.snp.left).offset(16)
        }
        
        view.addSubview(iconImage)
        iconImage.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.height.equalTo(80)
            $0.width.equalTo(120)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
        }
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, resetPasswordButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(iconImage.snp.bottom).offset(32)
            $0.left.equalTo(view.snp.left).offset(32)
            $0.right.equalTo(view.snp.right).offset(-32)
        }
    }
}

extension ResetPasswordController: FormViewModel {
    func updateForm() {
        resetPasswordButton.backgroundColor = viewModel.buttonBackgroundColor
        resetPasswordButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        resetPasswordButton.isEnabled = viewModel.formIsValid
    }
}
