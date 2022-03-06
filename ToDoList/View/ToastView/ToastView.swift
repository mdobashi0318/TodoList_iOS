//
//  ToastView.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2022/03/06.
//  Copyright © 2022 m.dobashi. All rights reserved.
//

import UIKit

class ToastView: UIView {

    @IBOutlet var view: UIView! {
        didSet {
            view.backgroundColor = .red
            view.layer.cornerRadius = view.frame.height / 3
        }
    }

    @IBOutlet weak var label: UILabel! {
        didSet {
            label.text = "期限の登録に失敗しました"

        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }

    func loadNib() {
        if let view = R.nib.toastView(owner: self) {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
