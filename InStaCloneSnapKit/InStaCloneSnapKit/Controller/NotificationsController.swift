//
//  NotificationsController.swift
//  InStaCloneSnapKit
//
//  Created by e2phus on 2022/12/20.
//

import UIKit

private let reuseIdentifier = "NotificationCell "

class NotificationsController: UITableViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
    }
    // MARK: - API
    
    
    // MARK: - Actions
    
    
    
    // MARK: - Helpers
    func configureTableView() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
    }
}

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.backgroundColor = .systemMint
        return cell
    }
}
