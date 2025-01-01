//
//  DetailsViewModel.swift
//  PodCastPackage
//
//  Created by islam Awaad on 28/12/2024.
//


import Foundation
import NetworkHandling
import Combine
import SwiftUICore

class DetailsViewModel: ObservableObject {
    
    let detailsLoader: DetailsLoader
    let dependencies : SessionDependencies
    var idDetails: Int
    var id: Int

    @Published var state = Status()
    init(dependencies : SessionDependencies,
         id: Int,
         idDetails: Int) {
        self.dependencies = dependencies
        self.id = id
        self.idDetails = idDetails
        self.detailsLoader = .init(client: dependencies.client, session: dependencies.session)
        Task { await loadRequest() }
    }
    
    @MainActor func loadRequest() async {
        state.state = .loading
        do {
            var item: RequestDetails!
            if let user = dependencies.session.user {
                switch user.role {
                case .Admin:
                    item = try await detailsLoader.loadAdminRequestDetails(id: idDetails)
                case .SuperVisor:
                    item = try await detailsLoader.loadSupervisorRequestDetails(id: idDetails)
                case .WorkerManager:
                    item = try await detailsLoader.loadWorkerManagerRequestDetails(id: idDetails)
                case .Worker:
                    item = try await detailsLoader.loadWorkerRequestDetails(id: idDetails)
                }
            }
            state.state = .success(item)
        }
        catch {
            state.state = .error(error.localizedDescription)
            dependencies.session.logout()
        }
    }
    
    @MainActor func postsupervisorActionOnAdmin() async {
        state.actionState = .loading
        do {
            let _ = try await detailsLoader.postsupervisorActionOnAdmin(
                body: .init(
                    requestID: "\(id)",
                    isAccepted: state.ActionForm.isAccepted,
                    acceptanceComment: state.ActionForm.acceptanceComment,
                    rejectionReason: state.ActionForm.rejectionReason,
                    rejectionComment: state.ActionForm.rejectionComment,
                    quantity: 1,
                    offerAmount: nil)
            )
            state.actionState = .success
        }
        catch {
            state.actionState = .error(error.localizedDescription)
            dependencies.session.logout()
        }
    }
    
    @MainActor func postsupervisorActionOnWorkerManager() async {
        state.actionState = .loading
        do {
            let _ = try await detailsLoader.postsupervisorActionOnWorkerManager(
                body: .init(
                    requestID: "\(id)",
                    isAccepted: state.ActionForm.isAccepted,
                    acceptanceComment: state.ActionForm.acceptanceComment,
                    rejectionReason: state.ActionForm.rejectionReason,
                    rejectionComment: state.ActionForm.rejectionComment,
                    quantity: 1,
                    offerAmount: nil)
            )
            state.actionState = .success
        }
        catch {
            state.actionState = .error(error.localizedDescription)
            dependencies.session.logout()
        }
    }
    
    @MainActor func postSupervisorActionOnWorker() async {
        state.actionState = .loading
        do {
            let _ = try await detailsLoader.postSupervisorActionOnWorker(
                body: .init(
                    requestID: "\(id)",
                    isAccepted: state.ActionForm.isAccepted,
                    acceptanceComment: state.ActionForm.acceptanceComment,
                    rejectionReason: state.ActionForm.rejectionReason,
                    rejectionComment: state.ActionForm.rejectionComment,
                    quantity: 1,
                    offerAmount: nil)
            )
            state.actionState = .success
        }
        catch {
            state.actionState = .error(error.localizedDescription)
            dependencies.session.logout()
        }
    }
    
    @MainActor func postaWorkerMangerAssignWorker() async {
        state.actionState = .loading
        do {
            let _ = try await detailsLoader.postaWorkerMangerAssignWorker(
                body: .init(
                    requestID: "\(id)",
                    isAccepted: state.ActionForm.isAccepted,
                    acceptanceComment: state.ActionForm.acceptanceComment,
                    rejectionReason: state.ActionForm.rejectionReason,
                    rejectionComment: state.ActionForm.rejectionComment,
                    quantity: 1,
                    offerAmount: nil)
            )
            state.actionState = .success
        }
        catch {
            state.actionState = .error(error.localizedDescription)
            dependencies.session.logout()
        }
    }
    
    @MainActor func postApiWorkermanagerActionOnSupervisor() async {
        state.actionState = .loading
        do {
            let _ = try await detailsLoader.postApiWorkermanagerActionOnSupervisor(fileURLWithPath: state.ActionForm.selectedPDF,
                body: [
                    "RequestId": id,
                    "IsAccepted": state.ActionForm.isAccepted ,
                    "AcceptanceComment": state.ActionForm.acceptanceComment,
                    "RejectionReason": state.ActionForm.rejectionReason?.rawValue,
                    "RejectionComment":state.ActionForm.rejectionComment.isEmpty ? nil : state.ActionForm.rejectionComment,
                    "OfferAmount": state.ActionForm.offerAmount,
                ], completion: { result in
                    if result {
                        self.state.actionState = .success
                    } else {
                        self.state.actionState = .error("")
                    }
                }
            )
        }
        catch {
            state.actionState = .error(error.localizedDescription)
            dependencies.session.logout()
        }
    }
    
    func uploadWorkerStartedSolvingIssueRequest() async {
        state.actionState = .loading
        do {
            let _ = try await detailsLoader.uploadWorkerStartedSolvingIssueRequest(imageDate: state.ActionForm.selectedImage?.data() ?? Data(), formDataDic: [
                "RequestId": "\(id)",
                "IsAccepted": "\(state.ActionForm.isAccepted)" ,
                "AcceptanceComment": "\(state.ActionForm.acceptanceComment)",
            ]) { result in
                if result {
                    self.state.actionState = .success
                }else {
                    self.state.actionState = .error("")
                }
            }
        }
        catch {
            state.actionState = .error(error.localizedDescription)
            dependencies.session.logout()
        }
    }
    
    func uploadWorkerIssueSolvedRequest() async {
        state.actionState = .loading
        do {
            let _ = try await detailsLoader.uploadWorkerIssueSolvedRequest(imageDate: state.ActionForm.selectedImage?.data() ?? Data(), formDataDic: [
                "RequestId": "\(id)",
                "IsAccepted": "\(state.ActionForm.isAccepted)" ,
                "AcceptanceComment": "\(state.ActionForm.acceptanceComment)",
            ]) { result in
                if result {
                    self.state.actionState = .success
                }else {
                    self.state.actionState = .error("")
                }
            }
        }
        catch {
            state.actionState = .error(error.localizedDescription)
            dependencies.session.logout()
        }
    }

    func HandleActionRequestState() {
        if let requestStatus = state.requestDetails?.requestStatus {
            switch requestStatus {
            case .PendingSupervisorAction:
                Task { await postsupervisorActionOnAdmin()}
            case .AssessmentAndGenerateOffer:
                Task { await postApiWorkermanagerActionOnSupervisor()}
            case .PendingOfferApproval:
                Task { await postsupervisorActionOnWorkerManager()}
            case .WorkerManagerAssignmentation:
                Task { await postaWorkerMangerAssignWorker() }
            case .WorkerDeparted:
                Task { await uploadWorkerStartedSolvingIssueRequest()}
            case .WorkerStartSolvingTheRequest:
                Task { await uploadWorkerIssueSolvedRequest()}
            case .IssueSolved:
                break
            case .VerifyOnSolvedIssueFromSupervisor:
                Task { await postSupervisorActionOnWorker()}

            case .IssueRejected:
                break
            }
        }
    }

    
    
    struct Status {
        
        var state: Status.State = .idle
        var actionState: Status.ActionsState = .idle
        var ActionForm = DetailsActions()
        
        enum State {
            case loading
            case success(RequestDetails)
            case error(String)
            case idle
        }
        
        enum ActionsState {
            case loading
            case success
            case error(String)
            case idle
        }
        
        var  requestDetails: RequestDetails? {
            if case .success(let item) = state {
                return item
            }
            return nil
        }
        
        
        var actionTitle: String {
            if let requestStatus = requestDetails?.requestStatus {
                switch requestStatus {
                case .PendingSupervisorAction:
                   return "PendingSupervisorAction"
                case .AssessmentAndGenerateOffer:
                    return "AssessmentAndGenerateOffer"
                case .PendingOfferApproval:
                    return "PendingOfferApproval"
                case .WorkerManagerAssignmentation:
                    return "WorkerManagerAssignmentation"
                case .WorkerDeparted:
                    return "WorkerDeparted"
                case .WorkerStartSolvingTheRequest:
                    return "WorkerStartSolvingTheRequest"
                case .IssueSolved:
                    return "IssueSolved"
                case .VerifyOnSolvedIssueFromSupervisor:
                    return "VerifyOnSolvedIssueFromSupervisor"
                case .IssueRejected:
                    return "IssueRejected"
                }
            } else {
                return "PendingSupervisorAction"
            }
        }
        
        
        struct DetailsActions {
            var requestID: String = ""
            var isAccepted: Bool = true
            var acceptanceComment: String = ""
            var rejectionReason: SupportEnums.RejectionReasonEnum? = nil
            var rejectionComment: String = ""
            var quantity: Int = 1
            var offerAmount: String = ""
            var selectedPDF: URL? = nil
            var selectedImage: Image? = nil
        }

    }
    
}
