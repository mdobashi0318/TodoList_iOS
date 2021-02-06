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
        ToDoModel.allDelete()
        presenter = ToDoListPresenter()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        ToDoModel.allDelete()
    }
    
    func test_fetchUsers() {
        let exp = expectation(description: "fetch")
        presenter?.fetchToDoList(segmentIndex: .all, success: {
            XCTAssertNotNil(self.presenter?.model, "モデルに格納されていない")
            exp.fulfill()
        }, failure: { error in
            XCTAssertNil(error, "エラーが入っている")
        })
        wait(for: [exp], timeout: 3.0)
    }
    
    func test_deleteTodo() {
         
         ToDoModel.addToDo(addValue: ToDoModel(id: "", toDoName: "UnitTestTitle", todoDate: "UnitDate", toDo: "UnitDetile", createTime: nil))
         
         let model = ToDoModel.findToDo(todoId: "0", createTime: nil)
         let exp = expectation(description: "exp")
         presenter?.deleteTodo(todoId: model?.id, createTime: model?.createTime, success: {
             XCTAssertTrue(ToDoModel.allFindToDo()?.count == 0, "ToDoが残っている")
             exp.fulfill()
             
         }, failure: { error in
             XCTAssertNil(error, "エラーが入っている")
         })
         wait(for: [exp], timeout: 3.0)
         
         
     }
    
    
    
    func test_allDeleteTodo() {
        
        ToDoModel.addToDo(addValue: ToDoModel(id: "", toDoName: "UnitTestTitle1", todoDate: "UnitDate", toDo: "UnitDetile", createTime: nil))
        sleep(1)
        ToDoModel.addToDo(addValue: ToDoModel(id: "", toDoName: "UnitTestTitle2", todoDate: "UnitDate", toDo: "UnitDetile", createTime: nil))
        sleep(1)
        
        
        presenter?.allDelete(success: {
            XCTAssertTrue(ToDoModel.allFindToDo()?.count == 0, "ToDoが残っている")
            
        }, failure: { error in
            XCTAssertNil(error, "エラーが入っている")
        })
        
    }
    
    
}
