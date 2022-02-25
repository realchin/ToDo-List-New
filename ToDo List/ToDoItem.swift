//
//  ToDoItem.swift
//  ToDo List
//
//  Created by Timothy Chin on 2/18/22.
//

import Foundation

struct ToDoItem: Codable {
    var name: String
    var date: Date
    var notes: String
    var reminderSet: Bool
    var notificationID: String?
    var completed: Bool
}
