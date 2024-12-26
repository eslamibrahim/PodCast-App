//
//  LottieView.swift
//  PodCastPackage
//
//  Created by islam Awaad on 20/12/2024.
//

import Lottie
import SwiftUI

public extension UIView {

    @discardableResult
    func autoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    func pinToAllEdges(
        _ view: UIView,
        padding: CGFloat = 0
    ) {
        addConstraints([
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            view.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }

    
}
