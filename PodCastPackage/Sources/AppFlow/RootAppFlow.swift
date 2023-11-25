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
import UI
import Combine

public class RootAppFlow: UIViewController {
    let dependencies: SessionDependencies
    lazy var loginVC = makeLoginScreen()
    lazy var mainTabsView = makeRootMainTabBarController()
    var subscriptions = Set<AnyCancellable>()

    public init() {
        self.dependencies = SessionDependencies(client : .live, session: .live)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        bind()
        addVC(child: loginVC)
    }
    
    func makeLoginScreen() -> UIViewController {
        let viewModel = LoginViewModel(dependencies: dependencies)
        let vc = UIHostingController(rootView: LoginView(viewModel: viewModel))
        return vc
    }
    
    func makeRootMainTabBarController() -> UIViewController {
       let root =  RootMainTabBarController(dependencies: dependencies)
        return root
    }
    
    func bind() {
        dependencies
            .session
            .loginStatus
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] loginStatus in
                guard let self else {return}
                if case .loggedIn = loginStatus {
                    self.loginVC.remove()
                    self.addVC(child: self.mainTabsView)
                }
        }
        .store(in: &subscriptions)
    }
    
    
    
}

public struct RootAppFlowView: UIViewControllerRepresentable {
    
    public init() {}
    
    public func makeUIViewController(context: Context) -> RootAppFlow {
        let viewController = RootAppFlow()
        return viewController
    }
    
    public func updateUIViewController(_ uiView: RootAppFlow, context: Context) {
        
    }
}
