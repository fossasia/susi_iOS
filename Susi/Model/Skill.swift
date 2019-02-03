//
//  Skill.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-08-24.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit

struct SkillListingCellViewModel {
    var skill: [Skill]?
    var groupName: String?
    var isLoading: Bool = false
    weak var skillListController: SkillSelectionProtocol?
    let count = 3
    
    init(skill: [Skill]?, isLoading: Bool, groupName: String?, skillListController: SkillSelectionProtocol?) {
        self.skill = skill
        self.isLoading = isLoading
        self.groupName = groupName
        self.skillListController = skillListController
    }
}

class Skill: NSObject {

    var imagePath: String = ""
    var authorUrl: String = ""
    var examples: [String] = []
    var author: String = ""
    var skillName: String = ""
    var skillDescription: String = ""
    var dynamic_content: Bool = false
    var skill_rating: [String: Any] = [:]
    var stars: [String: Any] = [:]
    var oneStar: Int = 0
    var twoStar: Int = 0
    var threeStar: Int = 0
    var fourStar: Int = 0
    var fiveStar: Int = 0
    var totalRatings: Int = 0
    var averageRating: Double = 0.0
    var skillKeyName: String = ""
    var model: String = ""
    var group: String = ""
    var language: String = ""


    init(dictionary: [String: AnyObject], skillKey: String) {
        super.init()
        authorUrl = dictionary[Client.SkillListing.authorURL] as? String ?? ""
        examples = dictionary[Client.SkillListing.examples] as? [String] ?? []
        author = dictionary[Client.SkillListing.author] as? String ?? ""
        skillName = dictionary[Client.SkillListing.skillName] as? String ?? "Skill Name"
        skillDescription = dictionary[Client.SkillListing.description] as? String ?? "Skill Description"
        imagePath = dictionary[Client.SkillListing.image] as? String ?? ""
        dynamic_content = dictionary[Client.SkillListing.dynamicContent] as? Bool ?? false
        skill_rating = dictionary[Client.SkillListing.skillRating] as? [String: Any] ?? [:]
        stars = skill_rating[Client.FiveStarRating.stars] as? [String: Any] ?? [:]
        oneStar = stars[Client.FiveStarRating.oneStar] as? Int ?? 0
        twoStar = stars[Client.FiveStarRating.twoStar] as? Int ?? 0
        threeStar = stars[Client.FiveStarRating.threeStar] as? Int ?? 0
        fourStar = stars[Client.FiveStarRating.fourStar] as? Int ?? 0
        fiveStar = stars[Client.FiveStarRating.fiveSatr] as? Int ?? 0
        totalRatings = stars[Client.FiveStarRating.totalStar] as? Int ?? 0
        averageRating = stars[Client.FiveStarRating.average] as? Double ?? 0.0
        skillKeyName = skillKey
        model = dictionary[Client.SkillListing.model] as? String ?? ""
        group = dictionary[Client.SkillListing.group] as? String ?? ""
        language = dictionary[Client.SkillListing.language] as? String ?? ""
    }

    static func getAllSkill(_ skills: [String: AnyObject], _ model: String, _ group: String, _ language: String) -> [Skill] {
        var skillData = [Skill]()
        for skill in skills {

            print(skill)
            guard let skillValueDictionary = skill.value as? [String: AnyObject] else {
                return skillData
            }
            let newSkill = Skill(dictionary: skillValueDictionary, skillKey: skill.0)
            newSkill.imagePath = getImagePath(model, group, language, newSkill.imagePath)
            guard let dict = skill.value as? [String: AnyObject] else {return skillData}
            if let skillRating = dict["skill_rating"] as? [String: AnyObject] {

                print(skillRating)
            }
            skillData.append(newSkill)
        }
        return skillData
    }

    static func getImagePath(_ model: String, _ group: String, _ language: String, _ path: String) -> String {
        return "\(Client.APIURLs.SusiAPI)\(Client.Methods.baseSkillImagePath)?model=\(model)&language=\(language)&group=\(group)&image=\(path)".replacingOccurrences(of: " ", with: "%20")
    }

}
