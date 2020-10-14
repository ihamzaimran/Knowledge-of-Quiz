//
//  ScoreViewController.swift
//  Quiz Of Knowledge
//
//  Created by Intern on 08/10/2020.
//

import UIKit

class ScoreViewController: UIViewController, UIGestureRecognizerDelegate {

    //MARK:-IBOutlets
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var titleBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        setIpadSettings()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
    }
    
    //MARK:- functions to change views settings depending on the device
    
    // adjusting settings for ipad for better user experience
    private func setIpadSettings(){
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            titleLBL.font = UIFont.init(name: Constants.Fonts.comfartaaBold, size: 40)
            titleBottomContraint.constant = -50
            buttonBottomConstraint.constant = -50
        default:
            break
        }
    }
    
    //MARK:- buttons pressed functions
    @IBAction func backButton(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: ViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
}


//MARK:- extension TableView

extension ScoreViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCell.scoreBoardTableCell, for: indexPath) as! ScoreBoardTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
//        cell.categoryLBL?.font = UIFont.init(name: Constants.Fonts.comfartaaLight, size: 30)
//        cell.scoreLBL?.font = UIFont.init(name: Constants.Fonts.comfartaaLight, size: 30)
        cell.categoryLBL.text = "Random Category"
        cell.scoreLBL.text = "250"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
