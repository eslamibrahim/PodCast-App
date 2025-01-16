//
//  DetailsLoader.swift
//  PodCastPackage
//
//  Created by islam Awaad on 27/12/2024.
//

import Foundation
import NetworkHandling
import Alamofire

public class DetailsLoader {
    
    private let client: Client
    private let session: NetworkHandling.Session
    
    public init(client: Client, session: NetworkHandling.Session) {
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
    
    func postsupervisorActionOnAdmin(body: RequestDetailsActions) async throws {
         let request = URLRequest(
            method: .post,
             path: "api/v1/Supervisor/supervisor-action-on-admin",
             body: .encode(body),
             headers: [
                 .contentTypeJson,
                 .custom(key: "user-id", value: "\(session.token ?? "")")
             ]
         )
        let ـ = try await client.load(request)
        return
     }
    
    func postsupervisorActionOnWorkerManager(body: RequestDetailsActions) async throws {
         let request = URLRequest(
            method: .post,
             path: "api/v1/Supervisor/supervisor-action-on-worker-manager",
             body: .encode(body),
             headers: [
                 .contentTypeJson,
                 .custom(key: "user-id", value: "\(session.token ?? "")")
             ]
         )
        let ـ = try await client.load(request)
        return
     }
    
    func postSupervisorActionOnWorker(body: RequestDetailsActions) async throws {
         let request = URLRequest(
            method: .post,
             path: "api/v1/Admin/admin-action-on-worker",
             body: .encode(body),
             headers: [
                 .contentTypeJson,
                 .custom(key: "user-id", value: "\(session.token ?? "")")
             ]
         )
        let ـ = try await client.load(request)
        return
     }
    
    func postSupervisorActionOnWorkerManagerInvoiceAccepted(body: RequestDetailsActions) async throws {
         let request = URLRequest(
            method: .post,
             path: "api/v1/Supervisor/supervisor-action-on-worker-manager-invoice-accepted",
             body: .encode(body),
             headers: [
                 .contentTypeJson,
                 .custom(key: "user-id", value: "\(session.token ?? "")")
             ]
         )
        let ـ = try await client.load(request)
        return
     }
    
    
    
    func postApiWorkermanagerActionOnSupervisor(fileURLWithPath: URL?, body: [String: Any], completion: @escaping (Bool) -> Void) async throws {
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in body {
                    if let temp = value as? String {
                        print(temp, key )
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Bool {
                        print(temp, key )
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Int {
                        print(temp, key )
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                }
                if let fileURLWithPath {
                        print(fileURLWithPath.path)
                    let pdfData = try! Data(contentsOf: fileURLWithPath)
                    let data: Data = pdfData
                        multipartFormData.append(data , withName: "UploadedPDF", fileName: "UploadedPDF.pdf", mimeType:"application/pdf")
                }
            },
            to: URL(string: "https://bassemwwe9-001-site1.otempurl.com/api/v1/WorkerManger/worker-manager-action-on-supervisor")!, method: .post,
            headers: ["user-id":"\(session.token ?? "")"])
        .validate(statusCode: 200..<300)
        .response { resp in
            switch resp.result{
            case .failure(let error):
                completion(false)
                print(error)
            case.success( _):
                completion(true)
                print("🥶🥶Response after upload Img: (resp.result)")
            }
        }
     }
    
    
    func postApiWorkerManagerActionOnSupervisorUploadInvoice(fileURLWithPath: URL?, body: [String: Any], completion: @escaping (Bool) -> Void) async throws {
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in body {
                    if let temp = value as? String {
                        print(temp, key )
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Bool {
                        print(temp, key )
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Int {
                        print(temp, key )
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                }
                if let fileURLWithPath {
                        print(fileURLWithPath.path)
                    let pdfData = try! Data(contentsOf: fileURLWithPath)
                    let data: Data = pdfData
                        multipartFormData.append(data , withName: "UploadedPDF", fileName: "UploadedPDF.pdf", mimeType:"application/pdf")
                }
            },
            to: URL(string: "https://bassemwwe9-001-site1.otempurl.com/api/v1/WorkerManger/worker-manager-action-on-supervisor-upload-invoice")!, method: .post,
            headers: ["user-id":"\(session.token ?? "")"])
        .validate(statusCode: 200..<300)
        .response { resp in
            switch resp.result{
            case .failure(let error):
                completion(false)
                print(error)
            case.success( _):
                completion(true)
                print("🥶🥶Response after upload Img: (resp.result)")
            }
        }
     }
    
    
    func uploadWorkerStartedSolvingIssueRequest(imageDate: Data, formDataDic: [String: String], completion: @escaping (Bool) -> Void) {
        let parameterS = formDataDic
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameterS {
                        multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                multipartFormData.append(imageDate, withName: "UploadedImg" , fileName: "file.jpeg", mimeType: "image/jpeg")
            },
            to: URL(string: "https://bassemwwe9-001-site1.otempurl.com/api/v1/Worker/worker-solving-issue")!, method: .post,
            headers: ["user-id":"\(session.token ?? "")"])
        .validate(statusCode: 200..<300)
        .response { resp in
            
            switch resp.result{
            case .failure(let error):
                print(error)
                completion(false)
            case.success( _):
                completion(true)
                print("🥶🥶Response after upload Img: (resp.result)")
            }
        }
    }
    
    func uploadWorkerIssueSolvedRequest(imageDate: Data, formDataDic: [String: String], completion: @escaping (Bool) -> Void) {
        let parameterS = formDataDic
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameterS {
                        multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                multipartFormData.append(imageDate, withName: "UploadedImg" , fileName: "file.jpeg", mimeType: "image/jpeg")
            },
            to: URL(string: "https://bassemwwe9-001-site1.otempurl.com/api/v1/Worker/issue-solved")!, method: .post,
            headers: ["user-id":"\(session.token ?? "")"])
        .validate(statusCode: 200..<300)
        .response { resp in
            
            switch resp.result{
            case .failure(let error):
                print(error)
                completion(false)
            case.success( _):
                completion(true)
                print("🥶🥶Response after upload Img: (resp.result)")
            }
        }
    }
    
   
    
    
    func postaWorkerMangerAssignWorker(body: RequestDetailsActions) async throws {
         let request = URLRequest(
            method: .post,
             path: "api/v1/WorkerManger/assign-worker",
             body: .encode(body),
             headers: [
                 .contentTypeJson,
                 .custom(key: "user-id", value: "\(session.token ?? "")")
             ]
         )
        let ـ =  try await client.load(request)
        return
     }
    
}


public struct RequestDetails: Hashable, Codable {
    var requestId: Int
    var requestDetailsId: Int
    var englishName: String
    var arabicName: String?
    var supportLevel: SupportEnums.SupportLevelEnum
    var supportType: SupportEnums.SupportTypeEnum
    var issueType: SupportEnums.IssueTypeEnum
    var requestComment: String?
    var imageUpload: String?
    var imageUploadAfterFix: String?
    var requestStatus: SupportEnums.RequestStatusEnum
    var pdfUpload: String?
    var pdfUploadInvoice: String?
    var offerAmount: Int?
    var quantity: Int?
    var acceptanceComment: String?
    var requestDuration: String?
    var requesterInformation: RequesterInformation?
}


public struct RequesterInformation: Hashable, Codable {
    var englishName: String
    var userLocationName: String
    var userLocationMapLink: String
    var address: String?
    var userMobileNumber: String?
}


struct RequestDetailsActions: Codable {
    let requestID: String
    let isAccepted: Bool
    let acceptanceComment: String
    let rejectionReason: SupportEnums.RejectionReasonEnum?
    let rejectionComment: String?
    let quantity: Int
    let offerAmount: Double?
    let RequestDuration: Int?
    let requestComment: String?
    enum CodingKeys: String, CodingKey {
        case requestID = "requestId"
        case isAccepted, acceptanceComment, rejectionReason, rejectionComment, quantity, offerAmount, RequestDuration
        case requestComment = "requestComment"
    }
}


