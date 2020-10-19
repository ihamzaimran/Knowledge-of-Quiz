//
//  ScoreViewController.swift
//  Quiz Of Knowledge
//
//  Created by Intern on 08/10/2020.
//

import UIKit

class ScoreViewController: UIViewController {
    
    //MARK:-IBOutlets
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var titleBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    private let scoreModel = ScoreVCModel()
    private var data = [[String:String]]()
    private let helper = DBHelper()
    private let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setIpadSettings()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        populateDataIntoTableView()
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
    
    private func populateDataIntoTableView(){
        data = scoreModel.getScoreFomSQLite()
        print(data.count)
    }
    
    //MARK:- buttons pressed functions
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}


//MARK:- extension TableView

extension ScoreViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCell.scoreBoardTableCell, for: indexPath) as! ScoreBoardTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        switch (deviceIdiom) {
        case .pad:
            cell.categoryLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 30)
            cell.scoreLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 30)
        default:
            cell.categoryLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 25)
            cell.scoreLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 25)
        }
        
        if !data.isEmpty{
            cell.categoryLBL.text = data[indexPath.row]["name"]
            cell.scoreLBL.text = data[indexPath.row]["score"]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (deviceIdiom) {
        case .pad:
            return 100
        default:
            return 80
        }
    }
}
