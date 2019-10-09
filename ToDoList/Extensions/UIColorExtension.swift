//
//  UIColorExtension.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2019/04/25.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    
    class func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    
    
    /// ダークモードかどうかで色を変更する
    /// - Parameter light: lightまたは、iOS13以前の端末で設定する色
    /// - Parameter dark: ダークモード時の色
    class func changeAppearnceColor(light: UIColor, dark: UIColor) -> UIColor {
        
        if #available(iOS 13.0, *) {
            
            let color: UIColor = UIColor() { traitCollection -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .light:
                    return light
                case .dark:
                    return dark
                default:
                    return light
                }
            }
            return color
            
        } else {
            return light
        }
        
    }
}
