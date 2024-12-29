//
//  File.swift
//
//
//  Created by islam Awaad on 25/11/2023.
//

import Foundation
import UIKit
import NetworkHandling
import SwiftUI

class RootMainTabBarController: UITabBarController {
    
    
    let dependencies : SessionDependencies
    lazy var homeFlow = makeHomeFlow()
    
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
        let profileVC = UIHostingController(rootView: ProfileView(viewModel: .init(dependencies: self.dependencies)))
        let VC1 = setNavController(for: profileVC, title: "", image: UIImage(systemName: "ellipsis.circle")!, selectedImage: UIImage(systemName: "ellipsis.circle")!)
        
        viewControllers = [
            homeFlow,
            VC1
        ]
    }
    
    func makeHomeFlow() -> UIViewController {
        let playListFlow = HomeFlowViewController(dependencies: dependencies)
        playListFlow.tabBarItem.title = "الرئيسية"
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

