//
//  AddRequestLoader.swift
//  PodCastPackage
//
//  Created by islam Awaad on 28/12/2024.
//


import Foundation
import MobileCoreServices
import NetworkHandling
import Alamofire
public class AddRequestLoader {
    
   private let client: Client
    private let session: NetworkHandling.Session
    
    public init(client: Client, session: NetworkHandling.Session) {
        self.client = client
        self.session = session
    }
    
    func uploadRequest(imageDate: Data, formDataDic: [String: String], completion: @escaping (Bool) -> Void) {
        let parameterS = formDataDic
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameterS {
                        multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                multipartFormData.append(imageDate, withName: "ImageUpload" , fileName: "file.jpeg", mimeType: "image/jpeg")
            },
            to: URL(string: "https://bassemwwe9-001-site1.otempurl.com/api/v1/Admin")!, method: .post,
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
}
