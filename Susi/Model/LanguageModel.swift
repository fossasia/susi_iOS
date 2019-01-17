//
//  LanguageModel.swift
//  Susi
//
//  Created by Raghav on 05/01/19.
//  Copyright © 2019 FOSSAsia. All rights reserved.
//

import Foundation

class LanguageModel {
    
    var languageCode: String?
    var languageName: String?
    
    init(languageCode: String?, languageName: String?) {
        self.languageCode = languageCode
        self.languageName = languageName
    }
    class func getDefaultLanguageModel() -> LanguageModel {
        return LanguageModel(languageCode: "en", languageName: "English")
    }
}
