//
//  ViewController.swift
//  ios-task-app
//
//  Created by Son Hong Do on 02/10/2021.
//

import UIKit

class TasksViewController: UIViewController {

    @IBOutlet weak var menuSegmentedControl: UISegmentedControl!
    @IBOutlet weak var onGoingTasksTableView: UIView!
    @IBOutlet weak var doneTasksTableView: UIView!

    private let databaseManager = DatabaseManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()

        showContainerView(for: .ongoing)
    }

    private func setupSegmentedControl() {
        menuSegmentedControl.removeAllSegments()

        MenuSection.allCases.enumerated().forEach({ (index, section) in
            menuSegmentedControl.insertSegment(withTitle: section.rawValue, at: index, animated: false)
        })
        menuSegmentedControl.selectedSegmentIndex = 0
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showContainerView(for: .ongoing)
        case 1:
            showContainerView(for: .done)
        default:
            break
        }
    }

    private func showContainerView(for section: MenuSection) {
        switch section {
        case .ongoing:
            onGoingTasksTableView.isHidden = false
            doneTasksTableView.isHidden = true
        case .done:
            onGoingTasksTableView.isHidden = true
            doneTasksTableView.isHidden = false
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewTask",
            let destination = segue.destination as? NewTaskViewController {
            destination.delegate = self
        }
    }

    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showNewTask", sender: nil)
    }


}


extension TasksViewController: TasksVCDelegate {
    
    func didAddTask(_ task: Task) {
        presentingViewController?.dismiss(animated: false, completion: {
            [unowned self] in
            self.databaseManager.addTask(task, completion: {
                (result) in
                switch result {
                case .success:
                    print("yay")
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                }
            })
        })
        
        
    }

}
