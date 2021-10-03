//
//  Task.swift
//  ios-task-app
//
//  Created by Son Hong Do on 03/10/2021.
//

import Foundation
import FirebaseFirestoreSwift

struct Task: Identifiable, Codable {
    
    @DocumentID var id: String?
    @ServerTimestamp var createdAt: Date?
    let title: String
    
}
