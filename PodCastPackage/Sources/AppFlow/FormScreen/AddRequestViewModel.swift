//
//  AddRequestViewModel.swift
//  PodCastPackage
//
//  Created by islam Awaad on 28/12/2024.
//


import Foundation
import NetworkHandling
import Combine
import SwiftUICore

class AddRequestViewModel: ObservableObject {
    
    let addRequestLoader: AddRequestLoader
    let dependencies : SessionDependencies
    @Published var state = Status()
    init(dependencies : SessionDependencies) {
        self.dependencies = dependencies
        self.addRequestLoader = .init(client: dependencies.client, session: dependencies.session)
    }
    
    @MainActor func addRequests() async {
        state.state = .loading
        do {
            state.state = .success
        }
        catch {
            state.state = .error(error.localizedDescription)
            dependencies.session.logout()
        }
    }
    
    
    struct Status{
        
        var state: Status.State = .idle
        var formData = FormData()
        var isShowingImagePicker = false
        var selectedImage: Image?
        var isShowingPDFPicker = false
        var selectedPDF: String = ""
        
        var selectedSupportLevel: SupportEnums.SupportLevelEnum = .Low
        var selectedSupportType: SupportEnums.SupportTypeEnum = .Maintenance
        var selectedIssueType: SupportEnums.IssueTypeEnum = .Type1
        

        
        enum State: Hashable {
            case loading
            case success
            case error(String)
            case idle
        }
        
        struct FormData {
            var title: String = ""
            var description: String = ""
            var note: String = ""
            var location: String = ""
            var pdfName: String = ""
        }
        
    }
    
}
