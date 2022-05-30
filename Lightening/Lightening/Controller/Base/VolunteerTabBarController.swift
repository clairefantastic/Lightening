//
//  TabBarController.swift
//  Lightening
//
//  Created by claire on 2022/4/14.
//

import UIKit

enum VolunteerTab {

    case lobby
    
    case discovery

    case upload
    
    case map
    
    case profile

    func controller() -> UIViewController {

        var controller: UIViewController
        
        let config = Config.default
        
        let signalClient = SignalingClient()
        
        let webRTCClient = WebRTCClient(iceServers: config.webRTCIceServers)

        switch self {

        case .lobby: controller = UINavigationController(rootViewController: VolunteerLobbyViewController(
            signalClient: signalClient, webRTCClient: webRTCClient))
            
        case .discovery: controller = UINavigationController(rootViewController: VolunteerDiscoveryViewController())
        
        case .upload: controller = UINavigationController(rootViewController: UploadViewController())
            
        case .map: controller = UINavigationController(rootViewController: MapViewController())
            
        case .profile: controller =
            UINavigationController(rootViewController: VolunteerProfileViewController())

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
                image: UIImage.systemAsset(ImageAsset.video),
                selectedImage: UIImage.systemAsset(ImageAsset.video)
            )
            
        case .discovery:
            return UITabBarItem(
                title: "Discovery",
                image: UIImage.systemAsset(ImageAsset.discovery),
                selectedImage: UIImage.systemAsset(ImageAsset.discoveryFill)
            )
        
        case .upload:
            return UITabBarItem(
                title: "Upload",
                image: UIImage.systemAsset(ImageAsset.upload),
                selectedImage: UIImage.systemAsset(ImageAsset.upload)
            )
            
        case .map:
            return UITabBarItem(
                title: "Map",
                image: UIImage.systemAsset(ImageAsset.map),
                selectedImage: UIImage.systemAsset(ImageAsset.mapFill)
            )
        
        case .profile:
            return UITabBarItem(
                title: "Profile",
                image: UIImage.systemAsset(ImageAsset.person),
                selectedImage: UIImage.systemAsset(ImageAsset.personFill)
            )
            
        }
        
    }
}

class VolunteerTabBarController: UITabBarController {
    
    var count = 0
    
    private let tabs: [VolunteerTab] = [.lobby, .discovery, .upload, .map, .profile]
    
    var lobbyTabBarItem: UITabBarItem!
    
    var videoCallObserver: NSKeyValueObservation!
    
    let notificationKey1 = "com.volunteer.receiveCall"
    
    let notificationKey2 = "com.volunteer.endCall"

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = tabs.map({ $0.controller() })
        
        if #available(iOS 15.0, *) {
           let appearance = UITabBarAppearance()
           appearance.configureWithOpaqueBackground()
           appearance.backgroundColor = UIColor.lightBlue
           
           self.tabBar.standardAppearance = appearance
           self.tabBar.scrollEdgeAppearance = appearance
        }
        
        self.tabBar.tintColor = UIColor.black // tab bar icon tint color
        self.tabBar.isTranslucent = false
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "American Typewriter", size: 10)!], for: .normal)
        UITabBar.appearance().barTintColor = UIColor.lightBlue // tab bar background color

        lobbyTabBarItem = viewControllers?[0].tabBarItem

        lobbyTabBarItem.badgeColor = UIColor.orange
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifyIncomingCall), name: NSNotification.Name (notificationKey1), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(endCall), name: NSNotification.Name (notificationKey2), object: nil)
        
        let content = UNMutableNotificationContent()
        content.title = "Light up your day!"
        content.body = "Check out your daily picks :)"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 11
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { _ in
        })

    }
    
    @objc func notifyIncomingCall() {
        
        if count == 0 {
            let popUpViewController = PopUpViewController()
            popUpViewController.modalPresentationStyle = .overCurrentContext
            popUpViewController.modalTransitionStyle = .crossDissolve
            self.present(popUpViewController, animated: true, completion: nil)
            self.count += 1
        }
        
        self.lobbyTabBarItem.badgeValue = "1"
    }
    
    @objc func endCall() {
        self.lobbyTabBarItem.badgeValue = nil
        count = 0
    }

}
