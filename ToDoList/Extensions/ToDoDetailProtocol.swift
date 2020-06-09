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
extension ToDoDetailTableView: ToDoDetailProtocol {}


protocol ToDoDetailProtocol {}
extension ToDoDetailProtocol {
    func todoHeadrView(viewForHeaderInSection section: Int) -> UIView {
        let headerView:UIView = UIView()
        let headerLabel:UILabel = UILabel()
        
        switch section {
        case 0:
            headerLabel.text = "タイトル"
            headerLabel.accessibilityLabel = "titleLabel"
        case 1:
            headerLabel.text = "期限"
            headerLabel.accessibilityLabel = "dateLabel"
        case 2:
            headerLabel.text = "詳細"
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
}
