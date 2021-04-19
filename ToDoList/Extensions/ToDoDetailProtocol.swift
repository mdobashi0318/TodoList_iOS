//
//  ToDoDetailProtocol.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2019/04/25.
//  Copyright © 2019 m.dobashi. All rights reserved.
//

import Foundation
import UIKit


extension TodoRegisterTableView: ToDoDetailProtocol {}
extension ToDoDetailTableViewController: ToDoDetailProtocol {}


protocol ToDoDetailProtocol {}
extension ToDoDetailProtocol {
    
    func todoHeadrView(viewForHeaderInSection section: Int, isEditMode: Bool, isExpired: Bool) -> UIView {
        let headerView:UIView = UIView()
        let headerLabel:UILabel = UILabel()
        
        switch section {
        case 0:
            if isEditMode {
                headerLabel.text = "タイトル *必須"
                setAttributes(headerLabel)
            } else {
                headerLabel.text = "タイトル"
            }
            headerLabel.accessibilityLabel = "titleLabel"
            
        case 1:
            if isEditMode {
                headerLabel.text = "期限 *必須"
                setAttributes(headerLabel)
            } else {
                headerLabel.text = "期限"
            }
            headerLabel.accessibilityLabel = "dateLabel"
            
        case 2:
            if isEditMode {
                headerLabel.text = "詳細 *必須"
                setAttributes(headerLabel)
            } else if isExpired {
                headerLabel.text = "詳細 \(R.string.message.expiredText())"
                setExpiredAttributes(headerLabel)
            } else {
                headerLabel.text = "詳細"
            }
            headerLabel.accessibilityLabel = "detailLabel"
            
        default:
            break
        }
        
        headerView.addSubview(headerLabel)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        
        return headerView
    }
    
    
    
    private func setAttributes(_ label: UILabel) {
        let attrText = NSMutableAttributedString(string: label.text!)
        let attributes: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 12.0),
            .foregroundColor : UIColor.red,
        ]
        attrText.addAttributes(attributes, range: NSMakeRange(label.text!.count - 3, 3))
        label.attributedText = attrText
    }
    
    private func setExpiredAttributes(_ label: UILabel) {
        let attrText = NSMutableAttributedString(string: label.text!)
        let attributes: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 12.0),
            .foregroundColor : UIColor.red,
        ]
        attrText.addAttributes(attributes,
                               range: NSMakeRange(label.text!.count - R.string.message.expiredText().count,
                                                  R.string.message.expiredText().count))
        label.attributedText = attrText
    }
    
}
