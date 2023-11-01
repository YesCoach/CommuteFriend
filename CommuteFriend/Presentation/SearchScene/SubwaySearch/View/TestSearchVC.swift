//
//  TestSearchVC.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/12.
//

import UIKit

final class TestSearchVC: BaseViewController {

    private lazy var searchController = UISearchController(searchResultsController: nil)

    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemBackground
        navigationItem.title = "검색"
        navigationItem.searchController = searchController
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }
}
