//
//  SecondViewController.swift
//  SwiftyCompanion
//
//  Created by Serhii CHORNONOH on 7/10/19.
//  Copyright © 2019 Serhii CHORNONOH. All rights reserved.
//

import UIKit
import SwiftyJSON

class SecondViewController: UIViewController, UIScrollViewDelegate  {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var correctionLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var skillsTableView: UITableView!
    @IBOutlet weak var projectsTableView: UITableView!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var jsonData : JSON?
    var profileData : ProfileData?
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupProfileView()
        loadDataFromModel()
    }
    
    func setupProfileView() {
        self.photoImageView.layer.borderWidth = 2
        self.photoImageView.layer.masksToBounds = true
        self.photoImageView.layer.borderColor = UIColor.white.cgColor
        self.photoImageView.layer.cornerRadius = self.photoImageView.frame.height / 2
        self.progressView.clipsToBounds = true
        self.progressView.layer.cornerRadius = (self.progressView.frame.height / 2) * 3
        self.progressView.subviews[1].clipsToBounds = true
        self.progressView.layer.sublayers![1].cornerRadius = (self.progressView.frame.height / 2) * 3
    }
    

    func loadDataFromModel() {
        nameLabel.text = profileData?.name
        usernameLabel.text = profileData?.username
        phoneLabel.text = profileData?.phone
        walletLabel.text = profileData?.wallet
        correctionLabel.text = profileData?.correction
        locationLabel.text = profileData?.location
        levelLabel.text = profileData?.level
        progressView.progress = profileData!.progress
        photoImageView.image = profileData?.userPhotoImage
        
        skillsTableView.separatorColor = .clear
        skillsTableView.layer.cornerRadius = 7
        projectsTableView.separatorColor = .clear
        projectsTableView.layer.cornerRadius = 7
    }
    

}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == skillsTableView {
            return profileData!.skillsCount
        } else {
            return profileData!.projectsCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == skillsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "skillsCellIdentifire", for: indexPath) as! SkillsTableViewCell
            cell.skillLabel.text = "\(String(profileData!.skillNames[indexPath.row]!)) - level \(profileData!.skillLvls[indexPath.row]!)"
            cell.skillProgressBar.progress = modf(profileData!.skillLvls[indexPath.row]!).1
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "projectsCellIdentifire", for: indexPath) as! ProjectsTableViewCell
            cell.projectNameLabel.text = String(profileData!.projectName[indexPath.row]!)
            cell.markLabel.text = "\(String(describing: Int(profileData!.projectMark[indexPath.row]!))) %"
            cell.statusLabel.text = profileData!.projectProgress[indexPath.row]
            cell.statusLabel.textColor = setProjectStatusColor(statusLabel: cell.statusLabel.text!)
            return cell
        }
        
    }
    
    func setProjectStatusColor(statusLabel: String) -> UIColor {
        switch statusLabel {
        case "Finished":
            return UIColor(red:0.22, green:0.78, blue:0.45, alpha:1.0)
        case "Failure":
            return UIColor(red:0.78, green:0.22, blue:0.22, alpha:1.0)
        case "In Progress":
            return UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)
        default:
            return UIColor.black
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == skillsTableView {
            return "Skills"
        } else {
            return "Projects"
        }
    }
    
}

