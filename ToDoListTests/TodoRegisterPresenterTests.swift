//
//  TodoRegisterPresenteTests.swift
//  ToDoListTests
//
//  Created by 土橋正晴 on 2020/08/27.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import XCTest
@testable import ToDoList

class TodoRegisterPresenterTests: XCTestCase {
    
    var presenter: TodoRegisterPresenter?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ToDoModel.allDelete()
        presenter = TodoRegisterPresenter()
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

       func test_addTodo() {
         var exp = expectation(description: "add")
        presenter?.addTodo(addValue: ToDoModel(id: "", toDoName: "UnitTestTitle", todoDate: "UnitDate", toDo: "UnitDetile", createTime: nil), success: {
             exp.fulfill()
        }, failure: { error in
            XCTAssertNil(error, "エラーが入っている")
         })
         wait(for: [exp], timeout: 1.0)
        
        

        exp = expectation(description: "find")
        presenter?.findTodo(todoId: "0", createTime: nil, success: {
            XCTAssert(self.presenter?.model?.id == "0", "idが作成されていない")
            XCTAssert(self.presenter?.model?.toDoName == "UnitTestTitle", "toDoNameが作成されていない")
            XCTAssert(self.presenter?.model?.todoDate == "UnitDate", "UnitDateが作成されていない")
            XCTAssert(self.presenter?.model?.toDo == "UnitDetile", "toDoが作成されていない")
            XCTAssertNotNil(self.presenter?.model?.createTime, "toDoが作成されていない")
            
            exp.fulfill()
        }, failure: { error in
            XCTAssertNil(error, "エラーが入っている")
        })
        
         wait(for: [exp], timeout: 3.0)
        
        
     }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
