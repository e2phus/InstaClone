//
//  LoginController.swift
//  InStaCloneSnapKit
//
//  Created by e2phus on 2022/12/21.
//

import UIKit
import SnapKit

protocol AuthenticationDelegate: AnyObject {
    func authenticationDidComplete()
}

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel = LoginViewModel()
    
    weak var delegate: AuthenticationDelegate?
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let emailTextField: CusTomTextField = {
        let textField = CusTomTextField(placeholder: "Email")
        return textField
    }()
    
    private let passwordTextField: CusTomTextField = {
        let textField = CusTomTextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        // label.text = "Test StatusLabel"
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    private let findPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(UIColor(white: 1, alpha: 0.8), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 0.7287221488).withAlphaComponent(0.3)
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let leftLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(white: 1, alpha: 0.8)
        return view
    }()
    
    private let rightLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(white: 1, alpha: 0.8)
        return view
    }()
    
    private let orLabel: UILabel = {
        let label = UILabel()
        label.text = "Or"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    private let faceBookLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "f.square"), for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Facebook", for: .normal)
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 15) //<- 중요
        return button
    }()
    
    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(white: 1, alpha: 0.8)
        return view
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstSentence: "Don't have an account? ", secondSentence: "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        configureNotificationObservers()
    }
    
    // MARK: - Actions
    @objc func handleShowSignUp() {
        let controller = RegisterationViewController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        updateForm()
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        AuthService.logUserIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Failed to log user in \(error.localizedDescription)")
                return
            }
            
            self.delegate?.authenticationDidComplete()
            print("DEBUG: Success LogIn")
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        configureGradientLayer()
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    func configureLayout() {
        // LogoImageView
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.width.equalTo(120)
            make.height.equalTo(80)
        }
        
        // StackView
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(32)
            make.left.equalTo(view.snp.left).offset(32)
            make.right.equalTo(view.snp.right).offset(-32)
        }
        
        // StatusLabel
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(5)
            make.left.equalTo(view.snp.left).offset(32)
        }
        
        // FindPasswordButtonn
        view.addSubview(findPasswordButton)
        findPasswordButton.snp.makeConstraints { make in
            make.centerY.equalTo(statusLabel.snp.centerY)
            make.top.equalTo(stackView.snp.bottom).offset(5)
            make.right.equalTo(view.snp.right).offset(-32)
        }
        
        // LoginButton
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(findPasswordButton.snp.bottom).offset(35)
            make.left.equalTo(view.snp.left).offset(32)
            make.right.equalTo(view.snp.right).offset(-32)
        }
        
        // OrLabel
        view.addSubview(orLabel)
        orLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(loginButton.snp.bottom).offset(35)
        }
        
        // LeftLineView
        view.addSubview(leftLineView)
        leftLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.centerY.equalTo(orLabel.snp.centerY)
            make.left.equalTo(view.snp.left).offset(32)
            make.right.equalTo(orLabel.snp.left).offset(-10)
        }
        
        // RightLineView
        view.addSubview(rightLineView)
        leftLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.centerY.equalTo(orLabel.snp.centerY)
            make.left.equalTo(orLabel.snp.right).offset(10)
            make.right.equalTo(view.snp.right).offset(-32)
        }
        
        // FaceBook LogIn
        view.addSubview(faceBookLoginButton)
        faceBookLoginButton.snp.makeConstraints { make in
            make.top.equalTo(orLabel.snp.bottom).offset(35)
            make.left.equalTo(view.snp.left).offset(32)
            make.right.equalTo(view.snp.right).offset(-32)
        }
        
        // BottomLineView
        view.addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-45)
            make.left.equalTo(view.snp.left).offset(32)
            make.right.equalTo(view.snp.right).offset(-32)
        }
        
        // SignUpButton
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
        
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

// MARK: - FormViewModel
extension LoginViewController: FormViewModel {
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsValid
    }
}
