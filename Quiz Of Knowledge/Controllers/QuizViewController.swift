//
//  QuizViewController.swift
//  Quiz Of Knowledge
//
//  Created by Intern on 08/10/2020.
//

import UIKit

class QuizViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}
