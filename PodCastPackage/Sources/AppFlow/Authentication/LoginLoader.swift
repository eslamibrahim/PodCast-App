//
//  File.swift
//  
//
//  Created by islam Awaad on 25/11/2023.
//

import Foundation
import NetworkHandling

class LoginLoader {
    
   private let client: Client
   private let session: Session
    
   init(client: Client, session: Session) {
        self.client = client
        self.session = session
    }

    func login(
        email: String,
        password: String
    ) async throws {
        let body = ["userName": "\(email)", "password": password]
        let request = URLRequest(
            method: .post,
            path: "api/v1/User/login",
            body: .encode(body),
            headers: [
                .contentTypeJson
            ]
        )
      let authResponse = try await client.load(request, handle: .decoding(to: AuthResponse.self))
        session.save(token: "\(authResponse.userID)")
    }
    
}


struct AuthResponse: Codable {
    let userID: Int
    let englishName, arabicName, userLocationName: String
    let userLocationMapLink: String
    let userEmail, userMobileNumber: String
    let latitude, longitude: Double
    let address: String
    let role: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case englishName, arabicName, userLocationName, userLocationMapLink, userEmail, userMobileNumber, latitude, longitude, address, role
    }
}
