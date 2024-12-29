//
//  AddRequestLoader.swift
//  PodCastPackage
//
//  Created by islam Awaad on 28/12/2024.
//


import Foundation
import MobileCoreServices
import NetworkHandling

public class AddRequestLoader {
    
   private let client: Client
   private let session: Session
    
  public init(client: Client, session: Session) {
        self.client = client
        self.session = session
    }

    
//    func uploadRequest() {
//        let request = URLRequest(multipartFormData: { (formData) in
////            try? formData.append(fileUrl: URL(string: "path to file")!, name: "parameterKey")
////            formData.append(file: avatarData, name: "avatar", fileName: "myImage.jpg", mimeType: "image/jpeg")
//     
//            formData.append(value: "John Doe", name: "fullName")
//        },
//                                 url: .applicationDirectory,
//                                 method: .post,
//                                 headers: [:])
//    }
}

extension URLRequest {
    public enum HTTPMethod: String {
        case connect
        case delete
        case get
        case head
        case options
        case patch
        case post
        case put
        case trace
    }
    
    class MultipartFormData {
        var request: URLRequest
        private lazy var boundary: String = {
           return String(format: "%08X%08X", arc4random(), arc4random())
        }()
        
        init(request: URLRequest) {
            self.request = request
        }
        
        func append(value: String, name: String) {
            request.httpBody?.append("--\(boundary)\r\n".data())
            request.httpBody?.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data())
            request.httpBody?.append("\(value)\r\n".data())
        }
        
        func append(filePath: String, name: String) throws {
            let url = URL(fileURLWithPath: filePath)
            try append(fileUrl: url, name: name)
        }
        
        func append(fileUrl: URL, name: String) throws {
            let fileName = fileUrl.lastPathComponent
            let mimeType = contentType(for: fileUrl.pathExtension)
            try append(fileUrl: fileUrl, name: name, fileName: fileName, mimeType: mimeType)
        }
        
        func append(fileUrl: URL, name: String, fileName: String, mimeType: String) throws {
            let data = try Data(contentsOf: fileUrl)
            append(file: data, name: name, fileName: fileName, mimeType: mimeType)
        }
        
        func append(file: Data, name: String, fileName: String, mimeType: String) {
            request.httpBody?.append("--\(boundary)\r\n".data())
            request.httpBody?.append("Content-Disposition: form-data; name=\"\(name)\";".data())
            request.httpBody?.append("filename=\"\(fileName)\"\r\n".data())
            request.httpBody?.append("Content-Type: \(mimeType)\r\n\r\n".data())
            request.httpBody?.append(file)
            request.httpBody?.append("\r\n".data())
        }
        
        fileprivate func finalize() {
            request.httpBody?.append("--\(boundary)--\r\n".data())
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        }
    }
    
    init(multipartFormData constructingBlock: @escaping (_ formData: MultipartFormData) -> Void,
         url: URL,
         method: HTTPMethod = .post,
         headers: [String: String] = [:])
    {
        self.init(url: url)
        self.httpMethod = method.rawValue.uppercased()
        self.httpBody = Data()
        let formData = MultipartFormData(request: self)
        constructingBlock(formData)
        formData.finalize()
        self = formData.request
        for (k,v) in headers {
            self.addValue(v, forHTTPHeaderField: k)
        }
    }
}

fileprivate func contentType(for pathExtension: String) -> String {
    guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue() else {
        return "application/octet-stream"
    }
    let contentTypeCString = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue()
    guard let contentType = contentTypeCString as String? else {
        return "application/octet-stream"
    }
    return contentType
}

fileprivate extension String {
    func data() -> Data {
        return self.data(using: .utf8) ?? Data()
    }
}
