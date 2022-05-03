//
//  VisuallyImpairedTabBarController.swift
//  Lightening
//
//  Created by claire on 2022/4/25.
//

import UIKit

private enum VisuallyImpairedTab {

    case lobby
    
    case discovery
    
    case profile

    func controller() -> UIViewController {

        var controller: UIViewController
        
        let config = Config.default
        
        let signalingClient = SignalingClient()
        
        let webRTCClient = WebRTCClient(iceServers: config.webRTCIceServers)

        switch self {

        case .lobby: controller = UINavigationController(rootViewController: ImpairedLobbyViewController(
            signalClient: signalingClient, webRTCClient: webRTCClient))
            
        case .discovery: controller = UINavigationController(rootViewController: ImpairedDiscoveryViewController())
            
        case .profile: controller =
            UINavigationController(rootViewController: ImpairedProfileViewController())

        }

        controller.tabBarItem = tabBarItem()

        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)

        return controller
    }

    func tabBarItem() -> UITabBarItem {

        switch self {

        case .lobby:
            return UITabBarItem(
                title: "Video Call",
                image: UIImage(systemName: "video"),
                selectedImage: UIImage(systemName: "video")
            )
            
        case .discovery:
            return UITabBarItem(
                title: "Audio Files",
                image: UIImage(systemName: "rectangle.grid.2x2"),
                selectedImage: UIImage(systemName: "rectangle.grid.2x2.fill")
            )
        
        case .profile:
            return UITabBarItem(
                title: "Profile",
                image: UIImage(systemName: "person.circle"),
                selectedImage: UIImage(systemName: "person.circle.fill")
            )
            
        }
        
    }
}

class VisuallyImpairedTabBarController: UITabBarController {
    
    private let tabs: [VisuallyImpairedTab] = [.lobby, .discovery, .profile]

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = tabs.map({ $0.controller() })
        self.tabBar.tintColor = UIColor.black // tab bar icon tint color
        self.tabBar.isTranslucent = false
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "American Typewriter", size: 10)!], for: .normal)
        UITabBar.appearance().barTintColor = UIColor.hexStringToUIColor(hex: "#A2BDC6") // tab bar background color
    }

}
