//
//  PostViewModel.swift
//  InStaCloneSnapKit
//
//  Created by e2phus on 2022/12/22.
//

import UIKit
import ActiveLabel

struct PostViewModel {
    var post: Post
    
    var imageUrl: URL? {
        return URL(string: post.imageUrl)
    }
    
    var userProfileImageUrl: URL? {
        return URL(string: post.ownerImageUrl)
    }
    
    var username: String {
        return post.ownerUsername
    }
    
    var caption: String {
        return post.caption
    }
    
    var likes: Int {
        return post.likes
    }
    
    var likesLabelText: String {
        if post.likes != 1 {
            return "\(post.likes) likes"
        } else {
            return "\(post.likes) like"
        }
    }
    
    var likeButtonImage: UIImage? {
        return post.didLike ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    var likeButtonTintColor: UIColor {
        return post.didLike ? .red : .black
    }
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        return formatter.string(from: post.timestamp.dateValue(), to: Date())
    }
    
    var customLabelType: ActiveType {
        return ActiveType.custom(pattern: "^\(username)\\b")
    }
    
    var enabledTypes: [ActiveType] {
        return [.mention, .hashtag, .url, customLabelType]
    }
    
    var configureLinkAttribute: ConfigureLinkAttribute {
        return { (type, attributes, isSelected) in
            var atts = attributes
            switch type {
            case .custom:
                atts[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: 14)
            default: ()
            }
            return atts
        }
    }
    
    func customizeLabel(_ label: ActiveLabel) {
        label.customize { label in
            label.text = "\(username) \(caption)"
            label.customColor[customLabelType] = .black
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .black
            label.numberOfLines = 2
        }
    }
    
    init(post: Post) {
        self.post = post
    }
}
