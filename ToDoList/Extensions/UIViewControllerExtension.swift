//
//  Extension.swift
//  Quiz
//
//  Created by 土橋正晴 on 2019/01/27.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    func frame_Size( _ viewController:UIViewController) -> CGRect {
        
        return CGRect(x: 0, y: (viewController.navigationController?.navigationBar.bounds.height)! +  UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - ((viewController.navigationController?.navigationBar.bounds.height)! + UIApplication.shared.statusBarFrame.size.height))
    }
    
    
    @objc func leftButtonAction(){
        self.dismiss(animated: true, completion: nil)
    }
}


