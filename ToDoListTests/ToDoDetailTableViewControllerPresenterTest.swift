//
//  ToDoDetailTableViewControllerPresenterTest.swift
//  ToDoListTests
//
//  Created by 土橋正晴 on 2020/09/06.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import XCTest
@testable import ToDoList

class ToDoDetailTableViewControllerPresenterTest: XCTestCase {

    var presenter: ToDoDetailTableViewControllerPresenter?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ToDoModel.allDelete()
        presenter = ToDoDetailTableViewControllerPresenter()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_findTodo() {

        ToDoModel.addToDo(addValue: ToDoModel(id: "", toDoName: "UnitTestTitle", todoDate: "UnitDate", toDo: "UnitDetile", createTime: nil)) { error in
            XCTAssertNil(error, "エラーが入っている")
        }
       

       let exp = expectation(description: "find")
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
    
    
    
    func test_deleteTodo() {
        
        ToDoModel.addToDo(addValue: ToDoModel(id: "", toDoName: "UnitTestTitle", todoDate: "UnitDate", toDo: "UnitDetile", createTime: nil)) { error in
            XCTAssertNil(error, "エラーが入っている")
        }
        
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


}
