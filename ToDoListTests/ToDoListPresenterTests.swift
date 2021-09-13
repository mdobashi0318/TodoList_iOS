//
//  ToDoListPresenterTests.swift
//  ToDoListTests
//
//  Created by 土橋正晴 on 2020/08/17.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import XCTest
@testable import ToDoList

class ToDoListPresenterTests: XCTestCase {

    var presenter: ToDoListPresenter?

    override func setUpWithError() throws {
        _ = ToDoModel.allDelete()
        presenter = ToDoListPresenter()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        _ = ToDoModel.allDelete()
    }

    func test_fetchUsers() {
        let exp = expectation(description: "fetch")
        presenter?.fetchToDoList(segmentIndex: .unfinished, success: {
            XCTAssertNotNil(self.presenter?.model, "モデルに格納されていない")
            exp.fulfill()
        }, failure: { error in
            XCTAssertNil(error, "エラーが入っている")
        })
        wait(for: [exp], timeout: 3.0)
    }

}
