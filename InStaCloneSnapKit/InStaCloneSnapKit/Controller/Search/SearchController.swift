//
//  SearchController.swift
//  InStaCloneSnapKit
//
//  Created by e2phus on 2022/12/20.
//

import UIKit

private let reuseIdentifier = "UserCell"
private let postCellIdentifier = "PostCell"

enum UserFilterConfig: Equatable {
    case followers(String)
    case following(String)
    case likes(String)
    case messages
    case all
    
    var navigationItemTitle: String {
        switch self {
        case .followers: return "Followers"
        case .following: return "Following"
        case .likes: return "Likes"
        case .messages: return "NewMessage"
        case .all: return "Search"
        }
    }
}

protocol SearchControllerDelegate: AnyObject {
    func controller(_ controller: SearchController, wantsToStartChatWith user: User)
}

class SearchController: UIViewController {
    
    // MARK: - Properties
    private var users = [User]()
    private var filteredUsers = [User]()
    private var posts = [Post]()
    private let searchController = UISearchController(searchResultsController: nil)
    private let config: UserFilterConfig
    weak var delegate: SearchControllerDelegate?
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let tableView = UITableView()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: postCellIdentifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    init(config: UserFilterConfig) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureUI()
        fetchUsers()
        fetchPosts()
    }
    
    // MARK: - API
    func fetchUsers() {
        UserService.fetchUsers(forConfig: config) { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    func fetchPosts() {
        PostService.fetchPosts { posts in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Helpers
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = config.navigationItemTitle
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 64
        tableView.isHidden = config == .all
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        guard config == .all else { return }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.viewModel = UserCellViewModel(user: user)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if config == .messages {
            delegate?.controller(self, wantsToStartChatWith: users[indexPath.row])
        } else {
            let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
            let controller = ProfileController(user: user)
            navigationController?.pushViewController(controller, animated: true)
        }
        
    }
}

// MARK: - UISearchResultsUpdating
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredUsers = users.filter({
            $0.username.lowercased().contains(searchText) || $0.fullname.lowercased().contains(searchText)
        })
        self.tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension SearchController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
        guard config == .all else { return }
        collectionView.isHidden = true
        tableView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        
        tableView.reloadData()
        
        guard config == .all else { return }
        collectionView.isHidden = false
        tableView.isHidden = true
    }
}

// MARK: - UICollectionViewDataSource
extension SearchController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellIdentifier, for: indexPath) as! ProfileCell
        cell.viewModel = PostViewModel(post: posts[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SearchController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FeedController(collectionViewLayout: UICollectionViewLayout())
        controller.post = posts[indexPath.item]
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
}




