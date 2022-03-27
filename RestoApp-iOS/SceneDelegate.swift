//
//  SceneDelegate.swift
//  RestoApp iOS
//
//  Created by Fahim Jatmiko on 17/03/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = makeMainVC() // Your initial view controller.
//        window.rootViewController = makeDetailVC()
        window.makeKeyAndVisible()
        self.window = window
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

    //MARK: Helpers
    private func makeMainVC() -> MainViewController {
        let vm = makeHomeViewModel()
        let vc = MainViewController(viewModel: vm)
        return vc
    }
    
    private func makeDetailVC() -> DetailViewController {
        let itemVM = ItemViewModel(id: "6176686afc13ae4e76000004", name: "Rosemary and bacon cupcakes", imageUrl: "https://i.picsum.photos/id/292/3852/2556.jpg?hmac=cPYEh0I48Xpek2DPFLxTBhlZnKVhQCJsbprR-Awl9lo", description: "Crumbly cupcakes made with dried rosemary and back bacon", tags: [
            "flour",
            "butter",
            "egg",
            "sugar",
            "rosemary",
            "bacon"
        ], displayedPrice: "SGD 3", price: 3, originalPrice: 3, originalDisplayedPrice: "SGD 3")
        let vm = makeDetailViewModel(itemViewModel: itemVM)
        let vc = DetailViewController(detailViewModel: vm)
        return vc
    }
    
    private func makeHomeViewModel() -> HomeViewModel {
        let menuLoader = makeRemoteMenuLoader()
        let vm = HomeViewModel(menuLoader: menuLoader)
        return vm
    }
    
    private func makeRemoteMenuLoader(file: StaticString = #filePath, line: UInt = #line) -> RemoteMenuLoader {
        let httpClient = makeHttpClient()
        let remoteMenuLoader = RemoteMenuLoader(httpClient: httpClient)
        return remoteMenuLoader
    }
    
    private func makeHttpClient(file: StaticString = #filePath, line: UInt = #line) -> HttpClient {
        let client = UrlSessionHttpClient(session: URLSession.shared)
        return client
    }
    
    private func makeDetailViewModel(itemViewModel:ItemViewModel) -> DetailViewModel {
        let itemDetailLoader = makeRemoteItemDetailLoader()
        let sut = DetailViewModel(itemDetailLoader: itemDetailLoader, menuItem: itemViewModel)
        return sut
    }
    
    private func makeRemoteItemDetailLoader() -> RemoteItemDetailLoader {
        let httpClient = makeHttpClient()
        let remoteMenuLoader = RemoteItemDetailLoader(httpClient: httpClient)
        return remoteMenuLoader
    }
}

