//
//  Message.swift
//  InStaCloneSnapKit
//
//  Created by blake on 2023/02/04.
//

import Firebase

struct Message {
    let text: String
    let toId: String
    let fromId: String
    let username: String
    var timestamp: Date?
    let profileImageUrl: String
    let isFromCurrentUser: Bool
    
    var chatPartnerId: String {
        return isFromCurrentUser ? toId : fromId
    }
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
}
