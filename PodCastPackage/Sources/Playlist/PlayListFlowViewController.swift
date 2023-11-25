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
    
    func makePlaylistScreenView() -> UIViewController {
        let vc = UIHostingController(rootView: PlaylistScreenView())
        return vc
    }
}
