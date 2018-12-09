//
//  AlertView.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2018/11/19.
//  Copyright © 2018 m.dobashi. All rights reserved.
//

import UIKit

class AlertManager {

     func alertAction(viewController:UIViewController, title: String, message: String, handler: @escaping (UIAlertAction) -> ()){
        let controller:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "閉じる",
                                           style: .default,
                                           handler: handler)
        )
        viewController.present(controller, animated: true, completion: nil)
    }

}
