//
//  AlertView.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/11/19.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import UIKit

struct AlertManager {

    enum AlertType: CaseIterable {
        case delete, close
    }

    /// アラートを表示する
    /// - Parameters:
    ///   - vc: ViewController
    ///   - type: 出すアラートのタイプを設定する
    func showAlert(_ vc: UIViewController, type: AlertType, title: String? = nil, message: String, didTapPositiveButton: ((UIAlertAction) -> Void)? = nil, didTapNegativeButton: ((UIAlertAction) -> Void)? = nil) {

        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)

        switch type {
        case .delete:
            controller.addAction(UIAlertAction(title: R.string.message.delete(),
                                               style: .destructive,
                                               handler: didTapPositiveButton)
            )

            controller.addAction(UIAlertAction(title: R.string.message.cancel(),
                                               style: .cancel,
                                               handler: didTapNegativeButton)
            )
        case .close:
            controller.addAction(UIAlertAction(title: R.string.message.close(),
                                               style: .cancel,
                                               handler: didTapPositiveButton))
        }

        vc.present(controller, animated: true, completion: nil)
    }

    /// アラートシートを作成する
    /// - Parameters:
    ///   - viewController: 表示するViewController
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - didTapEditButton: 編集ボタンタップ時の動作
    ///   - didTapDeleteButton: 削除ボタンタップ時の動作
    ///   - didTapCancelButton: キャンセルボタンタップ時の動作
    func alertSheetAction(_ viewController: UIViewController, title: String? = nil, message: String, didTapEditButton: @escaping (UIAlertAction) -> Void, didTapDeleteButton: @escaping (UIAlertAction) -> Void, didTapCancelButton: ((UIAlertAction) -> Void)? = nil) {

        let alertSheet = UIAlertController(title: title,
                                           message: message,
                                           preferredStyle: .actionSheet
        )
        alertSheet.addAction(UIAlertAction(title: R.string.message.edit(),
                                           style: .default,
                                           handler: didTapEditButton
        ))

        alertSheet.addAction(UIAlertAction(title: R.string.message.delete(),
                                           style: .destructive,
                                           handler: didTapDeleteButton
        ))

        alertSheet.addAction(UIAlertAction(title: R.string.message.cancel(),
                                           style: .cancel,
                                           handler: didTapCancelButton
        ))

        viewController.present(alertSheet, animated: true, completion: nil)
    }

}
