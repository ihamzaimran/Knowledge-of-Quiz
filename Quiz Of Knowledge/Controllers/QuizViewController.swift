//
//  QuizViewController.swift
//  Quiz Of Knowledge
//
//  Created by Intern on 08/10/2020.
//

import UIKit

class QuizViewController: UIViewController, UIGestureRecognizerDelegate {
    //MARK:- IBOutlets
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    //MARK:- variables
    
    private let imagesNames = Constants.Quiz.imagesNames
    private let categories = Constants.Quiz.categoryNames
    private let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        setIpadSettings()
    }
    
    
    //MARK:- functions to change views settings depending on the device
    
    // adjusting settings for ipad for better user experience
    private func setIpadSettings(){
        
        switch (deviceIdiom) {
        case .pad:
            titleLBL.font = UIFont.init(name: Constants.Fonts.comfartaaBold, size: 40)
            titleBottomConstraint.constant = -50
            buttonBottomConstraint.constant = -50
        default:
            break
        }
    }
    
    // MARK:- button functions
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK:- extension TableView

extension QuizViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.Quiz.imagesNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCell.quizVCTableViewCell, for: indexPath) as! QuizTableCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.quizCellImageView.image = UIImage(named: imagesNames[indexPath.row])
        cell.quizCellCategoryLBL.text = categories[indexPath.row]
        switch (deviceIdiom) {
        case .pad:
            cell.quizCellCategoryLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 40)
        default:
            cell.quizCellCategoryLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 22)
        }
        
        cell.quizCellCategoryLBL.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (deviceIdiom) {
        case .pad:
            return 120
        default:
            return 75
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(identifier: Constants.StoryboardIDs.gameRulesStoryboard) as! GameRulesViewController
        newVC.categoryID = indexPath.row + 1
        newVC.categoryName = categories[indexPath.row]
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}
