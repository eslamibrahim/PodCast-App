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
import Lottie

@available(iOS 18.0, *)
public class RootAppFlow: UIViewController {
    let dependencies: SessionDependencies
    lazy var loginVC = makeLoginScreen()
    lazy var mainTabsView = makeRootMainTabBarController()
    lazy var animationView = makeSplashAnimationView(fileName: "splash")
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
        showSplash()
    }

    private func showSplash() {
        animationView.play { [weak self] _ in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.3) {
                self.animationView.alpha = 0
            } completion: { _ in
                self.animationView.removeFromSuperview()
            }
            if dependencies.session.isLoggedIn {
                addVC(child: mainTabsView)
            } else {
                addVC(child: loginVC)
            }
        }
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
                } else {
                    self.mainTabsView.remove()
                    self.addVC(child: self.loginVC)
                    self.mainTabsView = self.makeRootMainTabBarController()
                }
        }
        .store(in: &subscriptions)
    }
    
    func makeSplashAnimationView(fileName: String) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: fileName).autoLayout()
        animationView.backgroundColor = .orange
        view.addSubview(animationView)
        view.pinToAllEdges(animationView)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        return animationView
    }

    
}

@available(iOS 18.0, *)
public struct RootAppFlowView: UIViewControllerRepresentable {
    
    public init() {
      
    }
    
    public func makeUIViewController(context: Context) -> RootAppFlow {
        let viewController = RootAppFlow()
        return viewController
    }
    
    public func updateUIViewController(_ uiView: RootAppFlow, context: Context) {
        
    }
}
