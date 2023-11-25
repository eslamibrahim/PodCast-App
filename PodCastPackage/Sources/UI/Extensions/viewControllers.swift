//
//  File.swift
//  
//
//  Created by islam Awaad on 25/11/2023.
//

import Foundation
import UIKit

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
