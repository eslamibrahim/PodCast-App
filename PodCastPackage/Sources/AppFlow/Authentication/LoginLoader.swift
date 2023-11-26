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
        let body = ["email": "\(email)", "password": password]
        let request = URLRequest(
            method: .post,
            path: "api/auth/login",
            body: .encode(body),
            headers: [
                .contentTypeJson
            ]
        )
      let authResponse = try await client.load(request, handle: .decoding(to: AuthResponse.self))
        session.save(token: authResponse.accessToken)
    }
    
}


struct AuthResponse: Codable {
    let accessToken: String
}
