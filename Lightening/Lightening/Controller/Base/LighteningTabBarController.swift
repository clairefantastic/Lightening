//
//  TabBarController.swift
//  Lightening
//
//  Created by claire on 2022/4/14.
//

import UIKit

private enum Tab {

    case lobby
    
    case discovery

    case upload

    func controller() -> UIViewController {

        var controller: UIViewController
        
        let config = Config.default
        
        let signalClientforVolunteer = SignalingClientforVolunteer()
        
        let webRTCClient = WebRTCClient(iceServers: config.webRTCIceServers)

        switch self {

        case .lobby: controller = VolLobbyViewController(
            signalClientforVolunteer: signalClientforVolunteer, webRTCClient: webRTCClient)
            
        case .discovery: controller = DiscoveryViewController()
        
        case .upload: controller = UploadViewController()

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
                image: UIImage(systemName: "video"),
                selectedImage: UIImage(systemName: "video")
            )
            
        case .discovery:
            return UITabBarItem(
                title: nil,
                image: UIImage(systemName: "rectangle.grid.2x2"),
                selectedImage: UIImage(systemName: "rectangle.grid.2x2.fill")
            )
        
        case .upload:
            return UITabBarItem(
                title: nil,
                image: UIImage(systemName: "arrow.up.heart"),
                selectedImage: UIImage(systemName: "arrow.up.heart")
            )

        
        }
    }
}
class LighteningTabBarController: UITabBarController {
    
    private let tabs: [Tab] = [.lobby, .discovery, .upload]
    
    var trolleyTabBarItem: UITabBarItem!
    
//    var orderObserver: NSKeyValueObservation!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = tabs.map({ $0.controller() })

//        trolleyTabBarItem = viewControllers?[2].tabBarItem
//
//        trolleyTabBarItem.badgeColor = .brown

    }

}
