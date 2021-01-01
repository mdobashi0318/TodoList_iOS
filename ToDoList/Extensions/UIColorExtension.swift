//
//  UIColorExtension.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2019/04/25.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// TodoListのセルの背景色
    static let todoListCell: UIColor = UIColor.changeAppearnceColor(light: .white, dark: .rgba(red: 25, green: 25, blue: 25, alpha: 1))
    
    /// Todoの登録、詳細の画面のセルの色
    static let cellColor: UIColor = UIColor.changeAppearnceColor(light: .white, dark: .rgba(red: 25, green: 25, blue: 25, alpha: 1))
    
    /// Todoの登録、詳細の画面のヘッダーの色
    static let headerColor: UIColor = UIColor.changeAppearnceColor(light: .white, dark: .black)
    
    
    class func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    
    
    /// ダークモードかどうかで色を変更する
    /// - Parameter light: lightまたは、iOS13以前の端末で設定する色
    /// - Parameter dark: ダークモード時の色
    class func changeAppearnceColor(light: UIColor, dark: UIColor) -> UIColor {
        
        if #available(iOS 13.0, *) {
            let color: UIColor = UIColor() { traitCollection -> UIColor in
                return traitCollection.userInterfaceStyle == .light ? light : dark
            }
            return color
            
        } else {
            return light
        }
        
    }
}
