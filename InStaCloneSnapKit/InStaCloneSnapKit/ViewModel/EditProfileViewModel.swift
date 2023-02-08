//
//  EditProfileViewModel.swift
//  InStaCloneSnapKit
//
//  Created by blake on 2023/02/07.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullname
    case username
    
    var description: String {
        switch self {
        case .fullname:
            return "Name"
        case .username:
            return "Username"
        }
    }
}

struct EditProfileViewModel {
    
    private let user: User
    let option: EditProfileOptions
    
    var titleText: String {
        return option.description
    }
    
    var optionValue: String? {
        switch option {
        case .username: return user.username
        case .fullname: return user.fullname
        }
    }
    
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
}
