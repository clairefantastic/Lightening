//
//  TabBarController.swift
//  Lightening
//
//  Created by claire on 2022/4/14.
//

import UIKit

private enum VolunteerTab {

    case lobby
    
    case discovery

    case upload
    
    case map
    
    case profile

    func controller() -> UIViewController {

        var controller: UIViewController
        
        let config = Config.default
        
        let signalClientforVolunteer = SignalingClientForVolunteer()
        
        let webRTCClient = WebRTCClient(iceServers: config.webRTCIceServers)

        switch self {

        case .lobby: controller = UINavigationController(rootViewController: VolunteerLobbyViewController(
            signalClientforVolunteer: signalClientforVolunteer, webRTCClient: webRTCClient))
            
        case .discovery: controller = UINavigationController(rootViewController: VolunteerDiscoveryViewController())
        
        case .upload: controller = UINavigationController(rootViewController: UploadViewController())
            
        case .map: controller = UINavigationController(rootViewController: MapViewController())
            
        case .profile: controller =
            UINavigationController(rootViewController: ProfileViewController())

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
            
        case .map:
            return UITabBarItem(
                title: nil,
                image: UIImage(systemName: "map"),
                selectedImage: UIImage(systemName: "map.fill")
            )
        
        case .profile:
            return UITabBarItem(
                title: nil,
                image: UIImage(systemName: "person.circle"),
                selectedImage: UIImage(systemName: "person.circle.fill")
            )
            
        }
        
    }
}

class VolunteerTabBarController: UITabBarController {
    
    private let tabs: [VolunteerTab] = [.lobby, .discovery, .upload, .map, .profile]
    
    var lobbyTabBarItem: UITabBarItem!
    
    var videoCallObserver: NSKeyValueObservation!
    
    let notificationKey1 = "com.volunteer.receiveCall"
    
    let notificationKey2 = "com.volunteer.endCall"

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = tabs.map({ $0.controller() })

        lobbyTabBarItem = viewControllers?[0].tabBarItem

        lobbyTabBarItem.badgeColor = .red
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifyIncomingCall), name: NSNotification.Name (notificationKey1), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(endCall), name: NSNotification.Name (notificationKey2), object: nil)

    }
    
    @objc func notifyIncomingCall() {
        self.lobbyTabBarItem.badgeValue = "1"
    }
    
    @objc func endCall() {
        self.lobbyTabBarItem.badgeValue = nil
    }

}
