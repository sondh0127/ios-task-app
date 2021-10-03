//
//  DatabaseManager.swift
//  ios-task-app
//
//  Created by Son Hong Do on 03/10/2021.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class DatabaseManager {

    private let db = Firestore.firestore()

    private lazy var tasksCollection = db.collection("tasks")

    func addTask(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            _ = try tasksCollection.addDocument(from: task, completion: { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            })
        } catch(let error) {
            completion(.failure(error))
        }
    }
}
