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
    
    var post: Post? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.app"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var heartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapHeartButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()
        fetchUser()
        
        if post != nil {
            checkIfUserLikedPosts()
        }
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
        if let post = post {
            PostService.checkIfUserLikedPost(post: post) { didLike in
                self.post?.didLike = didLike
            }
        } else {
            self.posts.forEach { post in
                PostService.checkIfUserLikedPost(post: post) { didLike in
                    print("Post is \(post.caption) and user liked is \(didLike)")
                    if let index = self.posts.firstIndex(where: { $0.postId == post.postId }) {
                        self.posts[index].didLike = didLike
                    }
                }
            }
        }
    }
    
    func deletePost(_ post: Post) {
        self.showLoader(true)
        
        PostService.deletePost(post.postId) { _ in
            self.showLoader(false)
            self.handleRefresh()
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
        let controller = NotificationsController()
        // let navigation = UINavigationController(rootViewController: controller)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func didTapShareButton() {
        print(#function)
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchPosts()
    }
    
    @objc func showMessages() {
        let controller = ConversationsController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helpers
    func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        }
        
        let stackView = UIStackView(arrangedSubviews: [plusButton, heartButton, shareButton])
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16

        let rightStackBarButtonItem = UIBarButtonItem(customView: stackView)
        navigationItem.rightBarButtonItem = rightStackBarButtonItem
        
        // navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "paperplane"), style:.plain, target: self, action: #selector(didTapShareButton)), UIBarButtonItem(image: UIImage(systemName: "heart"), style:.plain, target: self, action: #selector(didTapHeartButton)),UIBarButtonItem(image: UIImage(systemName: "plus.app"), style:.plain, target: self, action: #selector(didTapPlusButton))]
        
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
        height += 50
        height += 60
        return CGSize(width: width, height: height)
    }
}

// MARK: - UploadPostControllerDelegate
extension FeedController: UploadPostControllerDelegate {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        controller.dismiss(animated: true, completion: nil)
        self.handleRefresh()
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
        guard let tab = tabBarController as? MainTabController else { return }
        guard let user = tab.user else { return }
        guard let ownerUid = cell.viewModel?.post.ownerUid else { return }
        
        cell.viewModel?.post.didLike.toggle()
        if post.didLike {
            PostService.unlikePost(post: post) { _ in
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
                
                NotificationService.deleteNotification(toUid: ownerUid, type: .like, postId: cell.viewModel?.post.postId)
            }
        } else {
            PostService.likePost(post: post) { _ in
                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
                
                NotificationService.uploadNotification(toUid: post.ownerUid, fromUser: user, type: .like, post: post)
            }
        }
    }
    
    func cell(_ cell: FeedCell, wantsToShowOptionsForPost post: Post) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editPostAction = UIAlertAction(title: "Edit Post", style: .default) { _ in
            print("DEBUG: Edit post")
        }
        
        let deletePostAction = UIAlertAction(title: "Delete Post", style: .destructive) { _ in
            self.deletePost(post)
        }
        
        let unfollowAction = UIAlertAction(title: "Unfollow", style: .default) { _ in
            self.showLoader(true)
            UserService.unfollow(uid: post.ownerUid) { _ in
                self.showLoader(false)
            }
        }
        
        let followAction = UIAlertAction(title: "Follow", style: .default) { _ in
            self.showLoader(true)
            UserService.follow(uid: post.ownerUid) { _ in
                self.showLoader(false)
            }
        }
        
        let cancelAction =  UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if post.ownerUid == Auth.auth().currentUser?.uid {
            alert.addAction(editPostAction)
            alert.addAction(deletePostAction)
        } else {
            UserService.checkIfUserIsFollowed(uid: post.ownerUid) { isFollowed in
                if isFollowed {
                    alert.addAction(unfollowAction)
                } else {
                    alert.addAction(followAction)
                }
            }
        }
        
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func cell(_ cell: FeedCell, wantsToViewLikesFor postId: String) {
        let controller = SearchController(config: .likes(postId))
        navigationController?.pushViewController(controller, animated: true)
    }
}
