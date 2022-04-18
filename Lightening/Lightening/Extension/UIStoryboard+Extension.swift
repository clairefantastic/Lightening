//
//  UIStoryboard+Extension.swift
//  Lightening
//
//  Created by claire on 2022/4/12.
//

import UIKit

private struct StoryboardCategory {

    static let main = "Main"

    static let lobby = "Lobby"
    
    static let volunteerLobby = "VolunteerLobby"
}

extension UIStoryboard {

    static var main: UIStoryboard { return getStoryboard(name: StoryboardCategory.main) }

    static var lobby: UIStoryboard { return getStoryboard(name: StoryboardCategory.lobby) }
    
    static var volunteerLobby: UIStoryboard { return getStoryboard(name: StoryboardCategory.volunteerLobby) }

    private static func getStoryboard(name: String) -> UIStoryboard {

        return UIStoryboard(name: name, bundle: nil)
    }
}

