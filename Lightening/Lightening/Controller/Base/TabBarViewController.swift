//
//  TabBarViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/12.
//

import UIKit

private enum Tab {

    case lobby

    case volunteerLobby

    func controller() -> UIViewController {

        var controller: UIViewController

        switch self {

        case .lobby: controller = UIStoryboard.lobby.instantiateInitialViewController()!
            
        case .volunteerLobby: controller = UIStoryboard.volunteerLobby.instantiateInitialViewController()!


        }

        controller.tabBarItem = tabBarItem()

        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)

        return controller
    }

    func tabBarItem() -> UITabBarItem {

        switch self {

        case .lobby:
            return UITabBarItem(
                title: nil,
                image: UIImage(systemName: "phone.circle"),
                selectedImage: UIImage(systemName: "phone.circle")
            )
            
        case .volunteerLobby:
            return UITabBarItem(
                title: nil,
                image: UIImage(systemName: "phone.circle"),
                selectedImage: UIImage(systemName: "phone.circle")
            )

        }
    }
}

class STTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    private let tabs: [Tab] = [.lobby]
    
//    private let tabs: [Tab] = [.volunteerLobby]
    
//    var trolleyTabBarItem: UITabBarItem!
//
//    var orderObserver: NSKeyValueObservation!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = tabs.map({ $0.controller() })

//        trolleyTabBarItem = viewControllers?[2].tabBarItem
//
//        trolleyTabBarItem.badgeColor = .brown
        
        
        
        delegate = self
    }

    // MARK: - UITabBarControllerDelegate


}



