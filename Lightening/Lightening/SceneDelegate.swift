//
//  SceneDelegate.swift
//  Lightening
//
//  Created by claire on 2022/4/8.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    internal var window: UIWindow?
    private let config = Config.default

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard let _ = (scene as? UIWindowScene) else { return }
        guard let windowScene = (scene as? UIWindowScene) else { return }
                
//            let rootVC = LobbyViewController(nibName: String(describing: LobbyViewController.self), bundle: nil)
//            let navController = UINavigationController(rootViewController: rootVC)
                
            window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window?.windowScene = windowScene
//            window?.rootViewController = navController //navController
            
            window?.rootViewController = self.buildMainViewController()
            window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    private func buildMainViewController() -> UIViewController {
      let signalClient = SignalingClient()
      let signalClientforVolunteer = SignalingClientforVolunteer()
      let webRTCClient = WebRTCClient(iceServers: self.config.webRTCIceServers)
        
//      let mainViewController = LobbyViewController(signalClient: signalClient, webRTCClient: webRTCClient)
//
//      let navViewController = UINavigationController(rootViewController: mainViewController)
      let mainViewController = VolLobbyViewController(
        signalClientforVolunteer: signalClientforVolunteer, webRTCClient: webRTCClient)
      let tabBarController = TabBarController()
      let identitySelectionViewController = IdentitySelectionViewController()
      let signInViewController = SignInViewController()
      let navViewController = UINavigationController(rootViewController: signInViewController)
     
      return signInViewController
    }

}
