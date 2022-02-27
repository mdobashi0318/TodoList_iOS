//
//  UILabelExtension.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2022/02/27.
//  Copyright © 2022 m.dobashi. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func setExpiredAttributes() {
        guard let text = text else {
            return
        }

        let attrText = NSMutableAttributedString(string: text)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12.0),
            .foregroundColor: UIColor.red
        ]
        attrText.addAttributes(attributes,
                               range: NSRange(location: text.count - R.string.message.expiredText().count, length: R.string.message.expiredText().count))
        attributedText = attrText
    }

    func setAttributes() {
        guard let text = text else {
            return
        }

        let attrText = NSMutableAttributedString(string: text)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12.0),
            .foregroundColor: UIColor.red
        ]
        attrText.addAttributes(attributes, range: NSRange(location: text.count - 3, length: 3))
        attributedText = attrText
    }

}
