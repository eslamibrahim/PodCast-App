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

@available(iOS 18.0, *)
public class HomeFlowViewController: UINavigationController {
    
    let dependencies : SessionDependencies
    lazy var HomeScreen = makeHomeScreenView()
    var leftBarButtonItemView: UIView {
         UIImageView(image: UIImage(systemName: "arrow.backward"))
    }
    var rightBarButtonItemView: UIView {
         UIImageView(image: UIImage(systemName: "ellipsis"))
    }
   public init(dependencies: SessionDependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        setViewControllers([HomeScreen], animated: false)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func makeHomeScreenView() -> UIViewController {
        let viewModel = HomeViewModel(dependencies: dependencies)
        let vc = UIHostingController(rootView: AdminHomeListView(viewModel: viewModel, itemOnPressed: { idDetails, id in
            let viewController = DetailsFlowViewController(dependencies: self.dependencies, id: id, idDetails: idDetails)
            viewController.hidesBottomBarWhenPushed = true
            self.pushViewController(viewController, animated: true)
        }))
        return vc
    }
    
    
}
