//
//  ImageUploader.swift
//  InStaCloneSnapKit
//
//  Created by e2phus on 2022/12/21.
//

import FirebaseStorage

struct ImageUploader {
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let fileName = NSUUID().uuidString
        let reference = Storage.storage().reference(withPath: "/profile_images/\(fileName)")
        
        reference.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Failed to uploadImage \(error.localizedDescription)")
                return
            }
            
            reference.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}

