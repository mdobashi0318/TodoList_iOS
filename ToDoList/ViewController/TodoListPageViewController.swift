//
//  TodoListPageViewController.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2021/09/11.
//  Copyright © 2021 m.dobashi. All rights reserved.
//

import Foundation
import UIKit

class TodoListPageViewController: UIPageViewController {

    private var naviController: UINavigationController!

    private var pageType: PageType = .all

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        dataSource = self

        setViewControllers([ToDoListViewController(page: .all)], direction: .forward, animated: true)
    }

}

// MARK: - UIPageViewControllerDataSource

extension TodoListPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let vc = viewController as? ToDoListViewController else {
            return nil
        }

        switch vc.pageType {
        case .active:
            return ToDoListViewController(page: .all)
        case .expired:
            return ToDoListViewController(page: .active)
        default:
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? ToDoListViewController else {
            return nil
        }

        switch vc.pageType {
        case .all:
            return ToDoListViewController(page: .active)
        case .active:
            return ToDoListViewController(page: .expired)
        default:
            return nil
        }
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate

extension TodoListPageViewController: UIAdaptivePresentationControllerDelegate {

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        AlertManager().showAlert(presentationController.presentedViewController, type: .delete, message: "編集途中の内容がありますが削除しますか?", didTapPositiveButton: { [weak self] _ in
            self?.naviController.dismiss(animated: true) {
                NotificationCenter.default.post(name: Notification.Name(R.string.notification.tableReload()), object: nil)
            }
        })
    }

}

// MARK: - NavigationItem

extension TodoListPageViewController {

    /// setNavigationItemをセットする
    private func setNavigationItem() {
        self.title = "ToDoリスト"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.rightButtonAction))

        #if DEBUG
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(leftButtonAction))
        navigationItem.leftBarButtonItem?.accessibilityIdentifier = "allDelete"
        #endif
    }

    /// Todoの入力画面を開く
    @objc func rightButtonAction() {
        let inputViewController = TodoRegisterViewController()
        naviController = UINavigationController(rootViewController: inputViewController)
        naviController.presentationController?.delegate = self
        present(naviController, animated: true, completion: nil)
    }

    /// データベース内の全件削除(Debug)
    @objc override func leftButtonAction() {
        AlertManager().showAlert(self, type: .delete, message: "ToDoを全件削除しますか?", didTapPositiveButton: { _ in
            self.allDelete {
                NotificationCenter.default.post(name: Notification.Name(R.string.notification.tableReload()), object: nil)
            } failure: { error in
                AlertManager().showAlert(self, type: .close, message: error)
            }

        })
    }

    func allDelete(success: () -> Void, failure: @escaping (String) -> Void) {
        switch ToDoModel.allDelete() {
        case .success:
            success()
        case .failure(let error):
            failure(error.message)
        }
    }

}
