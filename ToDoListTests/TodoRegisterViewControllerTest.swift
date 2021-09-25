//
//  TodoRegisterViewControllerTest.swift
//  ToDoListTests
//
//  Created by 土橋正晴 on 2020/06/11.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import XCTest
@testable import ToDoList

class TodoRegisterViewControllerTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try? ToDoModel.allDelete()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

        try? ToDoModel.allDelete()
    }

    func test_init() {
        let vc = TodoRegisterViewController()

        XCTAssertNil(vc.getToDoModel(), "toDoModelが初期化されている")
        XCTAssertNil(vc.gettodoId(), "todoIdが初期化されている")
    }

    func test_ConvenienceInit() {
        let todoDate = Format().stringFromDate(date: Date())
        
        do {
            try ToDoModel.add(addValue: ToDoModel(id: "0",
                                                     toDoName: "UnitTest",
                                                     todoDate: todoDate,
                                                     toDo: "詳細",
                                                     completionFlag: CompletionFlag.unfinished.rawValue,
                                                     createTime: nil))
            let todoModel = ToDoModel.find(todoId: "0", createTime: nil)
            let vc = TodoRegisterViewController(todoId: todoModel!.id, createTime: todoModel?.createTime)

            XCTAssert(vc.gettodoId() == "0", "idが代入されていない")
            XCTAssert(vc.getToDoModel().id == "0", "idが代入されていない")
            XCTAssert(vc.getToDoModel().toDoName == "UnitTest", "Todoのタイトルが代入されていない")
            XCTAssert(vc.getToDoModel().todoDate == todoDate, "　Todoの期限が代入されていない")
            XCTAssert(vc.getToDoModel().toDo == "詳細", "　Todoの詳細が代入されていない")
            XCTAssert(vc.getToDoModel().createTime != nil, "Todo作成時間が代入されていない")
        } catch {
            XCTAssertNil(error)
        }
    }

    func test_ValidateCheck() {
        let vc = TodoRegisterViewController()

        vc.addText(toDoName: nil, todoDate: nil, toDo: nil)
        XCTAssertFalse(vc.getValidateCheck(), "バリデーションが通っている")

        vc.addText(toDoName: "toDoName", todoDate: nil, toDo: nil)
        XCTAssertFalse(vc.getValidateCheck(), "バリデーションが通っている")

        vc.addText(toDoName: "toDoName", todoDate: "todoDate", toDo: nil)
        XCTAssertFalse(vc.getValidateCheck(), "バリデーションが通っている")

        vc.addText(toDoName: "toDoName", todoDate: "todoDate", toDo: "toDo")
        XCTAssertTrue(vc.getValidateCheck(), "バリデーションが通らない")

    }

}
