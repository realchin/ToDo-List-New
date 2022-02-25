//
//  ToDoItems.swift
//  ToDo List
//
//  Created by Timothy Chin on 2/25/22.
//

import Foundation

class ToDoItems {
    var itemsArray: [ToDoItem] = [] // a struct inside of a class
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(itemsArray)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("🤬 ERROR: Could not save data \(error.localizedDescription)")
        }
    }
    
    func loadData(completed: @escaping ()->() ) {

        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")

        guard let data = try? Data(contentsOf: documentURL) else {return}
        let jsonDecoder = JSONDecoder()
        do {
            itemsArray = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
            
        } catch {
            print("🤬 ERROR: Could not save data \(error.localizedDescription)")
        }
        completed()
    }
}
