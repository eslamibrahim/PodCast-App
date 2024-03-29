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

public class PlayListFlowViewController: UINavigationController {
    
    let dependencies : SessionDependencies
    lazy var playlistScreen = makePlaylistScreenView()
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

        setViewControllers([playlistScreen], animated: false)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarHidden(true, animated: animated)
    }
    
    func makePlaylistScreenView() -> UIViewController {
        let viewModel = PlayListViewModel(dependencies: dependencies)
        let vc = UIHostingController(rootView: PlaylistScreenView(viewModel: viewModel))
        return vc
    }
}
