//
//  DetailsLoader.swift
//  PodCastPackage
//
//  Created by islam Awaad on 27/12/2024.
//

import Foundation
import NetworkHandling

public class DetailsLoader {
    
    private let client: Client
    private let session: Session
    
    public init(client: Client, session: Session) {
        self.client = client
        self.session = session
    }
    
    public func loadAdminRequestDetails(id: Int) async throws -> RequestDetails {
        let request = URLRequest(
            method: .get,
            path: "api/v1/Admin/\(id)",
            headers: [
                .contentTypeJson,
                .custom(key: "user-id", value: "\(session.token ?? "")")
            ]
        )
        let response = try await client.load(request, handle: .decoding(to: RequestDetails.self))
        return response
    }
    
    public func loadSupervisorRequestDetails(id: Int) async throws -> RequestDetails  {
         let request = URLRequest(
             method: .get,
             path: "api/v1/Supervisor/\(id)",
             headers: [
                 .contentTypeJson,
                 .custom(key: "user-id", value: "\(session.token ?? "")")
             ]
         )
        let response = try await client.load(request, handle: .decoding(to: RequestDetails.self))
        return response
     }
    
    public func loadWorkerRequestDetails(id: Int) async throws -> RequestDetails  {
         let request = URLRequest(
             method: .get,
             path: "api/v1/Worker/\(id)",
             headers: [
                 .contentTypeJson,
                 .custom(key: "user-id", value: "\(session.token ?? "")")
             ]
         )
        let response = try await client.load(request, handle: .decoding(to: RequestDetails.self))
        return response
     }
    
    public func loadWorkerManagerRequestDetails(id: Int) async throws -> RequestDetails  {
         let request = URLRequest(
             method: .get,
             path: "api/v1/WorkerManger/\(id)",
             headers: [
                 .contentTypeJson,
                 .custom(key: "user-id", value: "\(session.token ?? "")")
             ]
         )
        let response = try await client.load(request, handle: .decoding(to: RequestDetails.self))
        return response
     }
    
}


public struct RequestDetails:Hashable, Codable {
    var requestDetailsId: Int
    var requestId: Int
    var englishName: String
    var arabicName: String
    var supportLevel: SupportEnums.SupportLevelEnum
    var supportType: SupportEnums.SupportTypeEnum
    var issueType: SupportEnums.IssueTypeEnum
    var requestComment: String
    var imageUpload: String
    var requestStatus: SupportEnums.RequestStatusEnum
    var quantity: Int
    var pdfUpload :String?
    var offerAmount :Double?
}
