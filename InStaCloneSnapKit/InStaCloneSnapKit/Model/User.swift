//
//  User.swift
//  InStaCloneSnapKit
//
//  Created by e2phus on 2022/12/21.

import Firebase
import UIKit

struct User {
    let email: String
    var fullname: String
    var username: String
    var profileImageUrl: String
    let uid: String
    let fcmToken: String
    
    var isFollowed = false
    
    var stats: UserStats!
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.fcmToken = dictionary["fcmToken"] as? String ?? ""
        self.stats = UserStats(followers: 0, following: 0, posts: 0)
    }
}

struct UserStats {
    let followers: Int
    let following: Int
    let posts: Int
}
