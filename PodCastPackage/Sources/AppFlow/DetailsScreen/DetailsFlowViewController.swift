//
//  DetailsFlowViewController.swift
//  PodCastPackage
//
//  Created by islam Awaad on 29/12/2024.
//

import Foundation
import UIKit
import NetworkHandling
import SwiftUI

@available(iOS 18.0, *)
public class DetailsFlowViewController: UIViewController {
    
    let dependencies : SessionDependencies
    let id: Int
    let idDetails: Int
    lazy var DetailsScreen = makeDetailsScreenView()
    var leftBarButtonItemView: UIView {
         UIImageView(image: UIImage(systemName: "arrow.backward"))
    }
    var rightBarButtonItemView: UIView {
         UIImageView(image: UIImage(systemName: "ellipsis"))
    }
   public init(dependencies: SessionDependencies, id: Int, idDetails: Int) {
        self.dependencies = dependencies
       self.id = id
       self.idDetails = idDetails
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        addVC(child: DetailsScreen)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.setTabBarHidden(true, animated: true)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.setTabBarHidden(false, animated: true)
    }
    
    func makeDetailsScreenView() -> UIViewController {
        let viewModel = DetailsViewModel(dependencies: dependencies, id: id, idDetails: idDetails)
        let vc = UIHostingController(rootView: RequestDetailsView(viewModel: viewModel))
        return vc
    }

}



public extension UIViewController {
    
    func addVC(
        child childViewController: UIViewController,
        toView containerView: UIView? = nil,
        inset: UIEdgeInsets = .zero,
        constraintToBottomSafeArea: Bool = false
    ) {
        var containerView = containerView
        if containerView == nil {
            containerView = view
        }
        self.addChild(childViewController)
        containerView?.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childViewController.view.topAnchor.constraint(
                equalTo: containerView!.topAnchor,
                constant: inset.top
            ),
            childViewController.view.bottomAnchor.constraint(
                equalTo: constraintToBottomSafeArea ? containerView!.safeAreaLayoutGuide.bottomAnchor : containerView!.bottomAnchor,
                constant: -inset.bottom
            ),
            childViewController.view.leadingAnchor.constraint(
                equalTo: containerView!.leadingAnchor,
                constant: inset.left
            ),
            childViewController.view.trailingAnchor.constraint(
                equalTo: containerView!.trailingAnchor,
                constant: -inset.right
            )
        ])
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
