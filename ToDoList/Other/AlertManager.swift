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
    func alertAction(_ viewController:UIViewController, title: String? = nil, message: String, didTapCloseButton: @escaping (UIAlertAction) -> ()){
        
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
    func alertAction(_ viewController:UIViewController, title: String? = nil, message: String, didTapDeleteButton: @escaping (UIAlertAction) -> (), didTapCancelButton: @escaping (UIAlertAction) -> ()){
        
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
}
