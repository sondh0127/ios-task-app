//
//  ModalViewController.swift
//  ios-task-app
//
//  Created by Son Hong Do on 02/10/2021.
//

import UIKit
import Combine

class NewTaskViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var taskTextField: UITextField!

    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    weak var delegate: TasksVCDelegate?
    
    private var subscribers = Set<AnyCancellable>()
    @Published private var taskString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGesture()
        observeKeyboard()
        observeForm()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        taskTextField.becomeFirstResponder()
    }
    
    private func observeForm() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: nil).map ({
            ($0.object as? UITextField)?.text
        }).sink(receiveValue: {
            [unowned self] (text) in
            self.taskString = text
        }).store(in: &subscribers)
        
        $taskString.sink(receiveValue: {
            [unowned self] (text) in
            self.saveButton.isEnabled = text?.isEmpty == false
        }).store(in: &subscribers)
    }

    private func setupViews() {
        backgroundView.backgroundColor = UIColor.init(white: 0.3, alpha: 0.4)
        containerViewBottomConstraint.constant = -containerView.frame.height
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))

        view.addGestureRecognizer(tapGesture)
    }

    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        let keyboardHeight = getKeyboardHeight(notification)

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { [unowned self] in
            self.containerViewBottomConstraint.constant = keyboardHeight - (200 + 8)
            self.view.layoutIfNeeded()
        }, completion: nil)


    }

    @objc private func keyboardWillHide(_ notification: Notification) {

        containerViewBottomConstraint.constant = -containerView.frame.height
    }

    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return 0 }

        return keyboardHeight
    }

    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }


    @IBAction func calendarButtonTapped(_ sender: Any) {
        print("calendarButtonTapped")
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        print("saveButtonTapped")
        
        guard let taskString = self.taskString else { return }

        let task = Task(title: taskString)
        
        delegate?.didAddTask(task)
        
    }
}
