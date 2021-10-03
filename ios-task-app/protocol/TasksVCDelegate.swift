//
//  TaskVCDelegate.swift
//  ios-task-app
//
//  Created by Son Hong Do on 03/10/2021.
//

import Foundation

protocol TasksVCDelegate: AnyObject {
    func didAddTask(_ task: Task)
}
