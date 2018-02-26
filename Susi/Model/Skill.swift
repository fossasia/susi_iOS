//
//  Skill.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-24.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

class Skill: NSObject {

    var imagePath: String = ""
    var authorUrl: String = ""
    var examples: [String] = []
    var author: String = ""
    var skillName: String = ""
    var skillDescription: String = ""
    var dynamic_content: Bool = false
    var skill_rating: [String: Any] = [:]

    init(dictionary: [String: AnyObject]) {
        super.init()
        authorUrl = dictionary[Client.SkillListing.authorURL] as? String ?? ""
        examples = dictionary[Client.SkillListing.examples] as? [String] ?? []
        author = dictionary[Client.SkillListing.author] as? String ?? ""
        skillName = dictionary[Client.SkillListing.skillName] as? String ?? "Skill Name"
        skillDescription = dictionary[Client.SkillListing.description] as? String ?? "Skill Description"
        imagePath = dictionary[Client.SkillListing.image] as? String ?? ""
        dynamic_content = dictionary[Client.SkillListing.dynamic_content] as? Bool ?? false
        skill_rating = dictionary[Client.SkillListing.skill_rating] as? [String: Any] ?? ["positive": 0, "negative": 0]
    }

    static func getAllSkill(_ skills: [String: AnyObject], _ model: String, _ group: String, _ language: String) -> [Skill] {
        var skillData = [Skill]()
        for skill in skills {

            print("hi i am skill")
            print(skill)
            let newSkill = Skill(dictionary: skill.value as! [String: AnyObject])
            newSkill.imagePath = getImagePath(model, group, language, newSkill.imagePath)
            let dict = skill.value as! [String: AnyObject]
            if let skillRating = dict["skill_rating"] as? [String: AnyObject] {

                print(skillRating)
            }
            skillData.append(newSkill)
        }
        return skillData
    }

    static func getImagePath(_ model: String, _ group: String, _ language: String, _ path: String) -> String {
        return "\(Client.Methods.baseSkillImagePath)\(model)/\(group)/\(language)/\(path)".replacingOccurrences(of: " ", with: "%20")
    }

}
