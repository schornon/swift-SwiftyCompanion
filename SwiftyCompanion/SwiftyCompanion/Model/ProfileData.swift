//
//  ProfileData.swift
//  SwiftyCompanion
//
//  Created by Serhii CHORNONOH on 7/11/19.
//  Copyright © 2019 Serhii CHORNONOH. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProfileData {
    
    var name = ""
    var username = ""
    var phone = ""
    var wallet = ""
    var correction = ""
    var level = ""
    var progress = Float(0)
    var location = ""
    var userPhotoImage = UIImage(named: "unknown_photo")
    var unknownPhoto = UIImage(named: "unknown_photo")
    
    var skillsCount = 0
    var projectsCount = 0
    var skillNames : [Int : String] = [:]
    var skillLvls : [Int : Float] = [:]
    
    var projectName : [Int : String] = [:]
    var projectMark : [Int : Float] = [:]
    var projectStatus : [Int : Bool] = [:]
    var projectProgress : [Int : String] = [:]
    
    var projectNameArray : [String] = []
    var projectMarkArray : [Float] = []
    var projectStatusArray : [Bool?] = []
    var projectProgressArray : [String] = []
    
    
    init(json: JSON) {
        for (key, value) in json {
            switch key {
            case "displayname":
                self.name = value.string!
            case "login":
                self.username = value.string!
            case "phone":
                self.phone = value.string!
            case "wallet":
                self.wallet = "Wallet: \(value.int!)"
            case "correction_point":
                self.correction = "Corrections: \(value.int!)"
            case "location":
                if value.string != nil {
                    self.location = value.string!
                } else {
                    self.location = "unavailable"
                }
            case "cursus_users":
                guard let val = value[0]["level"].float else { return }
                self.level = "Level: \(Int(val)) - \(Int(modf(val).1 * 100))%"
                self.progress = modf(val).1
                self.skillsCount = value[0]["skills"].count
                getSkillsFromJson(value: value[0])
                
            case "projects_users":
                    self.projectsCount = value.count
                    getProjectsFromJson(value: value)
                
            default:
                print("")
            }
        }
        getPhotoFromJson(photoUrl: json["image_url"].string!)
    }
    
    func getPhotoFromJson(photoUrl: String) {
        guard let url = URL(string: photoUrl) else {
            userPhotoImage = unknownPhoto
            return
        }
        guard let photo = NSData(contentsOf: url) else {
            userPhotoImage = unknownPhoto
            return
        }
        self.userPhotoImage = UIImage(data: photo as Data)
    }
    
    func getSkillsFromJson(value : JSON) {
        var j = 0
        for (_, data) in value["skills"] {
            skillNames[j] = data["name"].string!
            skillLvls[j] = data["level"].float!

            j += 1
        }
    }
    func getProjectsFromJson(value: JSON) {
        var i = 0
        for _ in value {
            if (value[i]["project"]["parent_id"].int == nil) &&
                (strstr(value[i]["project"]["slug"].string, "piscine-c-") == nil) {
                projectNameArray.append(value[i]["project"]["slug"].string!)
                projectStatusArray.append(value[i]["validated?"].bool)
                if projectStatusArray.last == true {
                    projectProgressArray.append("Finished")
                } else if projectStatusArray.last == false {
                    projectProgressArray.append("Failure")
                } else {
                    projectProgressArray.append("In Progress")
                }
                if (value[i]["final_mark"].float) != nil {
                    projectMarkArray.append(value[i]["final_mark"].float!)
                } else {
                    projectMarkArray.append(0)
                }
            }
            i += 1
        }
        self.projectsCount = projectNameArray.count
    }
}
