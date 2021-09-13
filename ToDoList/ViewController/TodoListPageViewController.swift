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

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        setPageControl()
        dataSource = self
        view.backgroundColor = .backgroundColor
        setViewControllers([ToDoListViewController(page: .unfinished)], direction: .forward, animated: true)

    }

    // MARK: UIPageControl

    private func setPageControl() {
        UIPageControl.appearance().pageIndicatorTintColor = .lightGray
        UIPageControl.appearance().currentPageIndicatorTintColor = .systemBlue
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        CompletionFlag.allCases.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        0
    }

}

// MARK: - UIPageViewControllerDataSource

extension TodoListPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let vc = viewController as? ToDoListViewController else {
            return nil
        }

        switch vc.completionFlag {
        case .expired:
            return ToDoListViewController(page: .unfinished)
        case .completion:
            return ToDoListViewController(page: .expired)
        default:
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? ToDoListViewController else {
            return nil
        }

        switch vc.completionFlag {
        case .unfinished:
            return ToDoListViewController(page: .expired)
        case .expired:
            return ToDoListViewController(page: .completion)
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
