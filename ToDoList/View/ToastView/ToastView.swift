//
//  ToastView.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2022/03/06.
//  Copyright © 2022 m.dobashi. All rights reserved.
//

import UIKit

final class ToastView: UIView {

    // MARK: Properties

    /// ToastViewのベースになるView
    @IBOutlet var view: UIView! {
        didSet {
            view.backgroundColor = .red
            view.layer.cornerRadius = view.frame.height / 3
            view.alpha = 0
        }
    }

    /// Toastに表示するテキスト
    @IBOutlet weak var label: UILabel! {
        didSet {
            label.text = "期限の登録に失敗しました"
        }
    }

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        center.x = UIScreen.main.bounds.width / 2
        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }

    // MARK: private func

    func loadNib() {
        if let view = R.nib.toastView(owner: self) {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }

    // MARK: func

    /// Toastを表示
    func show() {
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.view.alpha = 1
        }, completion: { _ in
            /// toastを削除
            UIView.animate(withDuration: 1, delay: 2, options: .curveEaseOut, animations: { [weak self] in
                self?.view.alpha = 0
            }, completion: { [weak self] _ in
                self?.removeFromSuperview()
            })
        })
    }
}
