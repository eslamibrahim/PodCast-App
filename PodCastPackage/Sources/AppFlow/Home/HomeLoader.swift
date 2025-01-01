//
//  File.swift
//  
//
//  Created by islam Awaad on 26/11/2023.
//

import Foundation

import Foundation
import NetworkHandling

public class HomeLoader {
    
   private let client: Client
   private let session: Session
    
  public init(client: Client, session: Session) {
        self.client = client
        self.session = session
    }

   public func loadAdminRequestsList() async throws -> [RequestElement] {
        let request = URLRequest(
            method: .get,
            path: "api/v1/Admin",
            headers: [
                .contentTypeJson,
                .custom(key: "user-id", value: "\(session.token ?? "")")
            ]
        )
      let listResponse = try await client.load(request, handle: .decoding(to: [RequestElement].self))
       return listResponse
    }
    
    public func loadSupervisorRequestsList() async throws -> [RequestElement] {
         let request = URLRequest(
             method: .get,
             path: "api/v1/Supervisor",
             headers: [
                 .contentTypeJson,
                 .custom(key: "user-id", value: "\(session.token ?? "")")
             ]
         )
       let listResponse = try await client.load(request, handle: .decoding(to: [RequestElement].self))
        return listResponse
     }
    
    public func loadWorkerRequestsList() async throws -> [RequestElement] {
         let request = URLRequest(
             method: .get,
             path: "api/v1/Worker",
             headers: [
                 .contentTypeJson,
                 .custom(key: "user-id", value: "\(session.token ?? "")")
             ]
         )
       let listResponse = try await client.load(request, handle: .decoding(to: [RequestElement].self))
        return listResponse
     }
    
    public func loadWorkerManagerRequestsList() async throws -> [RequestElement] {
         let request = URLRequest(
             method: .get,
             path: "api/v1/WorkerManger",
             headers: [
                 .contentTypeJson,
                 .custom(key: "user-id", value: "\(session.token ?? "")")
             ]
         )
       let listResponse = try await client.load(request, handle: .decoding(to: [RequestElement].self))
        return listResponse
     }
}


public struct RequestElement: Hashable, Codable {
    let requestID, requestDetailsID: Int
    let englishName, arabicName: String
    let supportLevel: SupportEnums.SupportLevelEnum
    let supportType: SupportEnums.SupportTypeEnum
    let quantity: Int
    let createdOn: String

    enum CodingKeys: String, CodingKey {
        case requestID = "requestId"
        case requestDetailsID = "requestDetailsId"
        case englishName, arabicName, supportLevel, supportType, quantity, createdOn
    }
}

public class SupportEnums
{
    public enum SupportLevelEnum: Int, Codable, CaseIterable
    {
        case Low = 1
        case Medium
        case High
        case Critical
        
        public var description: String {
            switch self {
            case .Low: return "Low"
            case .Medium: return "Medium"
            case .High: return "High"
            case .Critical: return "Critical"
            }
        }
    }
    
    public enum RequestStatusEnum: Int, Codable, CaseIterable {
        case PendingSupervisorAction = 1
        case AssessmentAndGenerateOffer
        case PendingOfferApproval
        case WorkerManagerAssignmentation
        case WorkerDeparted
        case WorkerStartSolvingTheRequest
        case VerifyOnSolvedIssueFromSupervisor
        case IssueSolved
        case IssueRejected
        
        var description: String {
            switch self {
            case .PendingSupervisorAction: return "PendingSupervisorAction"
            case .AssessmentAndGenerateOffer: return "AssessmentAndGenerateOffer"
            case .PendingOfferApproval: return "PendingOfferApproval"
            case .WorkerManagerAssignmentation: return "WorkerManagerAssignmentation"
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
        }
     }
    
    public enum SupportTypeEnum: Int, Codable, CaseIterable
    {
        case Maintenance = 1
        case Purchase
        
        var description: String
        {
            switch self
            {
            case .Maintenance: return "Maintenance"
            case .Purchase: return "Purchase"
            }
        }
    }
    
    public enum IssueTypeEnum: Int, Codable, CaseIterable
    {
//        case Type1 = 1, Type2, Type3, Type4, Type5, Type6, Type7, Type8, Type9, Type10, Type11
        case ACBreakdown = 1, PlumbingAccessoriesBreakdown, ExhaustFanBreakdown,
        ACSwitchBreakdown,
        WaterDynamoBreakdown,
        WashingMachineBreakdown,
        TubeLightBreakdown,
        FloatSystemBreakdown,
        WashingMachineAccessoriesBreakdown,
        MainElectricBreakerBreakdown
        
        var description: String
        {
            switch self
            {
            case .ACBreakdown: return "ACBreakdown"
            case .PlumbingAccessoriesBreakdown: return "PlumbingAccessoriesBreakdown"
            case .ACSwitchBreakdown: return "ACSwitchBreakdown"
            case .WaterDynamoBreakdown: return "WaterDynamoBreakdown"
            case .TubeLightBreakdown: return "TubeLightBreakdown"
            case .FloatSystemBreakdown: return "FloatSystemBreakdown"
            case .WashingMachineAccessoriesBreakdown: return "WashingMachineAccessoriesBreakdown"
            case .MainElectricBreakerBreakdown: return "MainElectricBreakerBreakdown"
            case .ExhaustFanBreakdown:
                return "ExhaustFanBreakdown"
            case .WashingMachineBreakdown:
                return "WashingMachineBreakdown"
            }
        }
    }
    
    public enum RejectionReasonEnum: Int, Codable, CaseIterable 
    {
        case RejectionReason1 = 1, RejectionReason2, RejectionReason3, RejectionReason4, RejectionReason5, RejectionReason6
        
        var description: String
        {
            switch self {
            case .RejectionReason1: return "RejectionReason1"
            case .RejectionReason2: return "RejectionReason2"
            case .RejectionReason3: return "RejectionReason3"
            case .RejectionReason4: return "RejectionReason4"
            case .RejectionReason5: return "RejectionReason5"
            case .RejectionReason6: return "RejectionReason6"
            }
        }
    }
    
}

