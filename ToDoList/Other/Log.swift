//
//  Log.swift
//  ToDoList
//
//  Created by 土橋正晴 on 2021/08/23.
//  Copyright © 2021 m.dobashi. All rights reserved.
//

import Foundation


struct Log {
    static func devprint(_ message: String) {
        #if DEBUG
        print("\(message)")
        #endif
    }
}
