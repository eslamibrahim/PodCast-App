//
//  File.swift
//
//
//  Created by islam Awaad on 25/11/2023.
//

import Foundation
import UIKit
import Playlist
import NetworkHandling

class RootMainTabBarController: UITabBarController {
    
    
    let dependencies : SessionDependencies
    lazy var playListFlow = makePlayListFlow()
    
    public init(dependencies: SessionDependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewControllers()
    }
    
    
    func setupViewControllers() {
        
        let VC1 = setNavController(for: UIViewController(), title: "البحث", image: UIImage(systemName: "magnifyingglass")!, selectedImage: UIImage(systemName: "magnifyingglass")!)
        let VC2 = setNavController(for: UIViewController(), title: "المكتبه", image: UIImage(systemName: "square.stack.3d.down.forward.fill")!, selectedImage: UIImage(systemName: "square.stack.3d.down.forward.fill")!)
        
        viewControllers = [
            playListFlow,
            VC1,
            VC2
        ]
    }
    
    func makePlayListFlow() -> UIViewController {
        let playListFlow = PlayListFlowViewController(dependencies: dependencies)
        playListFlow.tabBarItem.title = "Home"
        playListFlow.tabBarItem.image = UIImage(systemName: "house.fill")
        return playListFlow
    }
    
    func setNavController(for rootViewController: UIViewController,
                          title: String,
                          image: UIImage,
                          selectedImage: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
    
}

