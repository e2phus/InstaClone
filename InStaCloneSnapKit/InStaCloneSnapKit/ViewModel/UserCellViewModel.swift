//
//  UserCellViewModel.swift
//  InStaCloneSnapKit
//
//  Created by e2phus on 2022/12/21.
//

import UIKit

struct UserCellViewModel {
    private let user: User
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var fullname: String {
        return user.fullname
    }
    
    var username: String {
        return user.username
    }
    
    init(user: User) {
        self.user = user
    }
}
