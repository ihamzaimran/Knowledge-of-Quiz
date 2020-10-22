//
//  GameRulesViewController.swift
//  Quiz Of Knowledge
//
//  Created by Intern on 09/10/2020.
//

import UIKit
import SQLite3

class GameRulesViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var letsPlayLBL: UILabel!
    
    //MARK:- variables
    private let rulesImages = Constants.GameRules.helpImages
    private let ruleDescription = Constants.GameRules.rules
    private let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
    internal var categoryID: Int?
    internal var categoryName: String?
      
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        setIpadSettings()
    }
    
    
    //MARK:- functions to change views settings depending on the device
    
    // adjusting settings for ipad for better user experience
    private func setIpadSettings(){
        
        switch (deviceIdiom) {
        case .pad:
            titleLBL.font = UIFont.init(name: Constants.Fonts.comfartaaBold, size: 40)
            letsPlayLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 25)
            titleBottomConstraint.constant = -50
            buttonBottomConstraint.constant = -50
        default:
            break
        }
    }
    
    //MARK:- button functions
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            let newVC = storyboard.instantiateViewController(identifier: Constants.StoryboardIDs.selectedCategoryQuizStoryboard) as! SelectedQuizViewController
            newVC.categoryID = categoryID
            newVC.categoryName = categoryName
            self.navigationController?.pushViewController(newVC, animated: true)
        } else {
            let newVC = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardIDs.selectedCategoryQuizStoryboard) as! SelectedQuizViewController
            newVC.categoryID = categoryID
            newVC.categoryName = categoryName
            self.navigationController?.pushViewController(newVC, animated: true)
        }
       
    }
}


//MARK:- extension tableView

extension GameRulesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ruleDescription.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCell.gameRulesTableViewCell, for: indexPath) as! GameRulesTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        switch deviceIdiom {
        case .pad:
            cell.gameRulesDescLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 25)
        default:
            cell.gameRulesDescLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 16)
        }
        
        cell.gameRulesImageView.image = UIImage(named: rulesImages[indexPath.row])
        cell.gameRulesDescLBL.text = ruleDescription[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (deviceIdiom) {
        case .pad:
            return 120
        default:
            return 70
        }
    }
}

