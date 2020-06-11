//
//  AlertView.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/11/19.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import UIKit

struct AlertManager {
    
    /// 閉じるボタンが付いたアラート
    /// - Parameters:
    ///   - viewController: 表示するViewController
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - didTapCloseButton: 閉じるボタンタップ時の動作
    func alertAction(_ viewController:UIViewController, title: String? = nil, message: String, didTapCloseButton: ((UIAlertAction) -> Void)? = nil) {
        
        let controller:UIAlertController = UIAlertController(title: title,
                                                             message: message,
                                                             preferredStyle: .alert
        )
        
        controller.addAction(UIAlertAction(title: "閉じる",
                                           style: .cancel,
                                           handler: didTapCloseButton)
        )
        viewController.present(controller, animated: true, completion: nil)
    }
    
    
    
    
    /// 「削除」、「キャンセル」が付いたアラート
    /// - Parameters:
    ///   - viewController: 表示するViewController
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - didTapDeleteButton: 削除ボタンタップ時の動作
    ///   - didTapCancelButton: キャンセルボタンタップ時の動作
    func alertAction(_ viewController:UIViewController, title: String? = nil, message: String, didTapDeleteButton: @escaping (UIAlertAction) -> (), didTapCancelButton: ((UIAlertAction) -> Void)? = nil) {
        
        let controller:UIAlertController = UIAlertController(title: title,
                                                             message: message,
                                                             preferredStyle: .alert
        )
        
        controller.addAction(UIAlertAction(title: "削除",
                                           style: .destructive,
                                           handler: didTapDeleteButton)
        )
        
        controller.addAction(UIAlertAction(title: "キャンセル",
                                           style: .cancel,
                                           handler: didTapCancelButton)
        )
        viewController.present(controller, animated: true, completion: nil)
    }
    
    
    
    
    /// アラートシートを作成する
    /// - Parameters:
    ///   - viewController: 表示するViewController
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - didTapEditButton: 編集ボタンタップ時の動作
    ///   - didTapDeleteButton: 削除ボタンタップ時の動作
    ///   - didTapCancelButton: キャンセルボタンタップ時の動作
    func alertSheetAction(_ viewController:UIViewController, title: String? = nil, message: String, didTapEditButton: @escaping (UIAlertAction) -> (), didTapDeleteButton: @escaping (UIAlertAction) -> (), didTapCancelButton: ((UIAlertAction) -> Void)? = nil) {
        
        let alertSheet:UIAlertController = UIAlertController(title: title,
                                                             message: message,
                                                             preferredStyle: .actionSheet
        )
        alertSheet.addAction(UIAlertAction(title: "編集",
                                           style: .default,
                                           handler: didTapEditButton
        ))
        
        alertSheet.addAction(UIAlertAction(title: "削除",
                                           style: .destructive,
                                           handler: didTapDeleteButton
        ))
        
        alertSheet.addAction(UIAlertAction(title: "キャンセル",
                                           style: .cancel,
                                           handler: didTapCancelButton
        ))
        
        viewController.present(alertSheet,animated: true, completion: nil)
    }
    
    
}
