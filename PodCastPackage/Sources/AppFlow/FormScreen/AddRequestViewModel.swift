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
import UIKit
import SwiftUI
import Alamofire

class AddRequestViewModel: ObservableObject {
    
    let addRequestLoader: AddRequestLoader
    let dependencies : SessionDependencies
    @Published var state = Status()
    init(dependencies : SessionDependencies) {
        self.dependencies = dependencies
        self.addRequestLoader = .init(client: dependencies.client, session: dependencies.session)
    }
    @MainActor
    func addRequests()  {
        state.state = .loading
        do {
            addRequestLoader.uploadRequest(imageDate: state.selectedImage?.data() ?? Data(), formDataDic: [
                "EnglishName":state.formData.title,
                "ArabicName":state.formData.title,
                "SupportLevelId": "\(state.selectedSupportLevel.rawValue)",
                "SupportTypeId": "\(state.selectedSupportType.rawValue)",
                "IssueTypeId": "\(state.selectedIssueType.rawValue)",
                "RequestComment": state.formData.note,
                "Quantity" : "1"
            ], completion: { result in
                if result {
                    self.state.state = .success
                    self.state.isShowingAlert = true
                } else {
                    self.state.state = .error("")
                }
            })
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
        var selectedIssueType: SupportEnums.IssueTypeEnum = .ACBreakdown
        var isShowingAlert = false

        
        enum State: Hashable {
            case loading
            case success
            case error(String)
            case idle
        }
        
        struct FormData {
            var title: String = "tetst"
            var description: String = "tetst tetst tetst"
            var note: String = "eslam"
            var location: String = ""
            var pdfName: String = ""
        }
        
    }
    
}


extension Image {
    @MainActor
    func data() -> Data? {
        let coordinator = ImageCoordinator()
        let uiImage = self.getUIImage(newSize: CGSize(width: 300, height: 300))
        return coordinator.convertImageToData(uiImage)
    }
}

class ImageCoordinator {
    func convertImageToData(_ image: UIImage?) -> Data? {
        guard let image = image else {
            return nil
        }
        if let data = image.jpegData(compressionQuality: 0.1) {
            print(data)
            return data
        }
        return nil
    }
}


extension Image {
    @MainActor
    func getUIImage(newSize: CGSize) -> UIImage? {
        let image = resizable()
            .scaledToFill()
            .frame(width: newSize.width, height: newSize.height)
            .clipped()
        if #available(iOS 16.0, *) {
            return ImageRenderer(content: image).uiImage
        } else {
            return nil
        }
    }
}
