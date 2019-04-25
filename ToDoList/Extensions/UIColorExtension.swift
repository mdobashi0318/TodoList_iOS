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
}
