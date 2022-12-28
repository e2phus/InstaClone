//
//  AuthenticationViewModel.swift
//  InStaCloneSnapKit
//
//  Created by e2phus on 2022/12/21.
//

import UIKit

protocol FormViewModel {
    func updateForm()
}

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
    var buttonBackgroundColor: UIColor { get}
    var buttonTitleColor: UIColor { get }
}

struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 0.7287221488) : #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 0.7287221488).withAlphaComponent(0.3)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : .white.withAlphaComponent(0.7)
    }
}

struct RegisterationViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false && username?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 0.7287221488) : #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 0.7287221488).withAlphaComponent(0.3)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : .white.withAlphaComponent(0.7)
    }
}
