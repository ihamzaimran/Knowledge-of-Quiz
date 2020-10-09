//
//  Constants.swift
//  Quiz Of Knowledge
//
//  Created by Intern on 07/10/2020.
//

import Foundation

struct Constants {
    
    struct Fonts {
        static let comfartaaLight = "Comfortaa-Light"
        static let comfartaaRegular = "Comfortaa-Regular"
        static let comfartaaBold = "Comfortaa-Bold"
        static let codeBold = "Code-Bold"
    }
    
    struct AudioFiles{
        static let homePageAudio = "bg_music"
    }
    
    struct ImagesAssets {
        static let musicOn = "ic_sound_on"
        static let musicOff = "ic_music_off"
    }
    
    struct StoryboardIDs {
        static let aboutVCStoryboard = "aboutViewControllerStoryboard"
        static let scoreVCStoryboard = "scoreViewStoryboard"
        static let homeVCStoryboard = "homeViewStoryboard"
        static let quizVCStoryboard = "quizViewStoryboard"
        static let gameRulesStoryboard = "gameRulesViewStoryboard"
        static let selectedCategoryQuizStoryboard = "selectedCategoryQuizStoryboard"
    }
    
    struct OpenExternalLinks {
        static let twitterApp = "twitter://user?screen_name=LTHApps"
        static let twitterLink = "https://twitter.com/LTHApps"
        static let facebookApp = "fb://profile/134553613405965"
        static let facebookLink = "https://www.facebook.com/LTHApps/"
        static let aboutVCShareButtonDescription = "Quiz of Knowledge is free to download App."
        static let knowledgeOfQuizAppLink = "https://itunes.apple.com/pk/developer/suave-solutions/id415880778"
    }
    
    struct TableViewCell{
        static let scoreBoardTableCell = "scoreBoardCellIdentifier"
        static let quizVCTableViewCell = "quizTableCellIdentifier"
        static let gameRulesTableViewCell = "gamRulesCellIdentifier"
    }
    
    struct Quiz{
        static let categoryNames = ["Random", "History", "Geography", "Science", "Arts", "Technology",
                             "Food", "Music", "Entertainment", "Athletics", "Animals", "Space", "Mythology"]
        static let imagesNames = ["random", "history", "geography", "science", "arts", "technology", "food", "music", "entertainment", "athletics", "animals", "space", "mythology"]
    }
    
    struct GameRules {
        static let rules = ["Answer the question as fast as you can.", "You will have 20 Seconds to answer each question.", "You will have 3 Lives.", "For 5 correct answer in a row you gain one life.", "The faster you answer, the more points you earn."]
        static let helpImages = ["help1","help2","help3","help4","help5"]
    }
    
}
