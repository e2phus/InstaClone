//
//  FeedController.swift
//  InStaCloneSnapKit
//
//  Created by e2phus on 2022/12/20.
//

import UIKit
import Firebase
import YPImagePicker

private let reuseIdentifier = "FeedCell"

class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    var user: User? 
    
    private var posts = [Post]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var post: Post?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
        fetchPosts()
    }
    
    // MARK: - API
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser(withUid: uid) { user in
            self.user = user
        }
    }
    
    func fetchPosts() {
        guard post == nil else { return }
        
        PostService.fetchPosts { posts in
            self.posts = posts
            self.checkIfUserLikedPosts()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func checkIfUserLikedPosts() {
        self.posts.forEach { post in
            PostService.checkIfUserLikedPost(post: post) { didLike in
                print(#function)
                print("Post is \(post.caption) and user liked is \(didLike)")
                if let index = self.posts.firstIndex(where: { $0.postId == post.postId }) {
                    self.posts[index].didLike = didLike
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginViewController()
            controller.delegate = self.tabBarController as? MainTabController
            let navigation = UINavigationController(rootViewController: controller)
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true, completion: nil)
        } catch {
            print("Failed to Sign Out..")
        }
    }
    
    
    @objc func didTapPlusButton() {
        print(#function)
        var configuration = YPImagePickerConfiguration()
        configuration.library.mediaType = .photo
        configuration.shouldSaveNewPicturesToAlbum = false
        configuration.startOnScreen = .library
        configuration.screens = [.library]
        configuration.hidesStatusBar = false
        configuration.hidesBottomBar = false
        configuration.library.maxNumberOfItems = 1
        
        let picker = YPImagePicker(configuration: configuration)
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
        
        didFinishPickingMedia(picker)
    }
    
    @objc func didTapHeartButton() {
        print(#function)
    }
    
    @objc func didTapShareButton() {
        print(#function)
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchPosts()
    }
    
    // MARK: - Helpers
    func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        navigationItem.title = "Feed"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "paperplane"), style:.plain, target: self, action: #selector(didTapShareButton)),
                                              UIBarButtonItem(image: UIImage(systemName: "heart"), style:.plain, target: self, action: #selector(didTapHeartButton)),
                                              UIBarButtonItem(image: UIImage(systemName: "plus.app"), style:.plain, target: self, action: #selector(didTapPlusButton))]
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
        
    }
    
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                print("Debug: Selected Image is \(selectedImage)")
                
                let controller = UploadPostController()
                controller.selectedImage = selectedImage
                controller.delegate = self
                controller.currentUser = self.user
                let navigation = UINavigationController(rootViewController: controller)
                navigation.modalPresentationStyle = .fullScreen
                self.present(navigation, animated: false, completion: nil)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        if let post = post {
            cell.viewModel = PostViewModel(post: post)
        } else {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 110
        return CGSize(width: width, height: height)
    }
}

// Check !! 
extension FeedController: UploadPostControllerDelegate {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        controller.dismiss(animated: true, completion: nil)
        self.handleRefresh()
        // guard let feedNav = viewControllers?.first as? UINavigationController else { return }
        // guard let feed = feedNav.viewControllers.first as? FeedController else { return }
        
    }
}

// MARK: - FeedCellDelegate
extension FeedController: FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String) {
        UserService.fetchUser(withUid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: FeedCell, didLike post: Post) {
        print(#function)
        cell.viewModel?.post.didLike.toggle()
        if post.didLike {
            PostService.unlikePost(post: post) { _ in
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
        } else {
            PostService.likePost(post: post) { _ in
                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
            }
        }
    }
}
