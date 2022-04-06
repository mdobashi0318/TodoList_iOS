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
        try? ToDoModel.allDelete()
        presenter = ToDoListPresenter()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try? ToDoModel.allDelete()
    }

    // MARK: - fetchToDoList
    
    /// Todo未登録時にpresenter?.modelが空であること
    func test_fetchNoTodo() async {
        await presenter?.fetchToDoList(segmentIndex: .unfinished)
        XCTAssertTrue(self.presenter?.model == [], "Todoが空ではない")
        
        await presenter?.fetchToDoList(segmentIndex: .completion)
        XCTAssertTrue(self.presenter?.model == [], "Todoが空ではない")
        
        await presenter?.fetchToDoList(segmentIndex: .expired)
        XCTAssertTrue(self.presenter?.model == [], "Todoが空ではない")
    }
    
    /// Todo登録時にpresenter?.modelが空でないこと
    func test_fetchTodo() async {
        try? ToDoModel.add(addValue: ToDoModel(id: "", toDoName: "unfinishedTestTitle", todoDate: "2099/04/05 00:00", toDo: "詳細1", completionFlag: CompletionFlag.unfinished.rawValue, createTime: nil))
        
        await presenter?.fetchToDoList(segmentIndex: .unfinished)
        XCTAssertTrue(self.presenter?.model.count == 1, "モデルに格納されていない")
        XCTAssertTrue(self.presenter?.model[0].toDoName == "unfinishedTestTitle", "タイトルが異なる")
        XCTAssertTrue(self.presenter?.model[0].todoDate == "2099/04/05 00:00", "期日が異なる")
        XCTAssertTrue(self.presenter?.model[0].toDo == "詳細1", "Todoの詳細が異なる")
        XCTAssertTrue(self.presenter?.model[0].completionFlag == CompletionFlag.unfinished.rawValue, "completionFlagが異なる")
        
        
        try? ToDoModel.updateCompletionFlag(updateTodo: ToDoModel(id: "0", toDoName: "completionTestTitle", todoDate: "2099/04/06 00:00", toDo: "詳細1", completionFlag: CompletionFlag.unfinished.rawValue, createTime: nil), flag: .completion)
        
        await presenter?.fetchToDoList(segmentIndex: .completion)
        XCTAssertTrue(self.presenter?.model.count == 1, "モデルに格納されていない")
        XCTAssertTrue(self.presenter?.model[0].toDoName == "unfinishedTestTitle", "タイトルが異なる")
        XCTAssertTrue(self.presenter?.model[0].todoDate == "2099/04/05 00:00", "期日が異なる")
        XCTAssertTrue(self.presenter?.model[0].toDo == "詳細1", "Todoの詳細が異なる")
        XCTAssertTrue(self.presenter?.model[0].completionFlag == CompletionFlag.completion.rawValue, "completionFlagが異なる")
        
        
        try? ToDoModel.add(addValue: ToDoModel(id: "", toDoName: "expiredTestTitle", todoDate: "2000/04/07 00:00", toDo: "詳細3", completionFlag: CompletionFlag.expired.rawValue, createTime: nil))
        await presenter?.fetchToDoList(segmentIndex: .expired)
        XCTAssertTrue(self.presenter?.model.count == 1, "モデルに格納されていない")
        XCTAssertTrue(self.presenter?.model[0].toDoName == "expiredTestTitle", "タイトルが異なる")
        XCTAssertTrue(self.presenter?.model[0].todoDate == "2000/04/07 00:00", "期日が異なる")
        XCTAssertTrue(self.presenter?.model[0].toDo == "詳細3", "Todoの詳細が異なる")
        XCTAssertTrue(self.presenter?.model[0].completionFlag == CompletionFlag.unfinished.rawValue, "completionFlagが異なる")
    }
    
    
    
    // MARK: - isExpired
    
    /// isExpiredが「.expired」を返していること
    func test_isExpired_expired() async {
        try? ToDoModel.add(addValue: ToDoModel(id: "", toDoName: "unfinishedTestTitle", todoDate: "2000/04/05 00:00", toDo: "詳細1", completionFlag: CompletionFlag.unfinished.rawValue, createTime: nil))
        await presenter?.fetchToDoList(segmentIndex: .expired)
        
        XCTAssertTrue(presenter?.isExpired(row: 0) == .expired, "期限切れ判定になっていない")
    }
    
    /// isExpiredが「.unfinished」を返していること
    func test_isExpired_unfinished_expired() async {
        try? ToDoModel.add(addValue: ToDoModel(id: "", toDoName: "unfinishedTestTitle", todoDate: "2099/04/05 00:00", toDo: "詳細1", completionFlag: CompletionFlag.unfinished.rawValue, createTime: nil))
        await presenter?.fetchToDoList(segmentIndex: .unfinished)
        
        XCTAssertTrue(presenter?.isExpired(row: 0) == .unfinished, "未完了判定になってない")
    }
    
    
    /// isExpiredが「.completion」を返していること
    func test_isExpired_completion_expired() async {
        try? ToDoModel.add(addValue: ToDoModel(id: "", toDoName: "completionTestTitle", todoDate: "2099/04/05 00:00", toDo: "詳細1", completionFlag: CompletionFlag.unfinished.rawValue, createTime: nil))
        try? ToDoModel.updateCompletionFlag(updateTodo: ToDoModel(id: "0", toDoName: "completionTestTitle", todoDate: "2099/04/06 00:00", toDo: "詳細1", completionFlag: CompletionFlag.unfinished.rawValue, createTime: nil), flag: .completion)
        await presenter?.fetchToDoList(segmentIndex: .completion)
        
        XCTAssertTrue(presenter?.isExpired(row: 0) == .completion, "完了判定になっていない")
    }
    


}
