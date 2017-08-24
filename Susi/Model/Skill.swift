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

    init(dictionary: [String:AnyObject]) {
        super.init()
        authorUrl = dictionary[Client.SkillListing.authorURL] as? String ?? ""
        examples = dictionary[Client.SkillListing.examples] as? [String] ?? []
        author = dictionary[Client.SkillListing.author] as? String ?? ""
        skillName = dictionary[Client.SkillListing.skillName] as? String ?? ""
        skillDescription = dictionary[Client.SkillListing.description] as? String ?? ""
        imagePath = getImagePath("model", skillName, "en", (dictionary[Client.SkillListing.image] as? String ?? ""))
    }

    static func getAllSkill(_ skills: [String : AnyObject]) -> [Skill] {
        var skillData = [Skill]()
        for skill in skills {
            let newSkill = Skill(dictionary: skill.value as! [String : AnyObject])
            skillData.append(newSkill)
        }
        return skillData
    }

    func getImagePath(_ model: String, _ skillName: String, _ language: String, _ path: String) -> String {
        return "\(Client.Methods.baseSkillImagePath)\(skillName)/\(language)/\(path)"
    }

}
