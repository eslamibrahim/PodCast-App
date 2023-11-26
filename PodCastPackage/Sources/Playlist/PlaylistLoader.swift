//
//  File.swift
//  
//
//  Created by islam Awaad on 26/11/2023.
//

import Foundation

import Foundation
import NetworkHandling

public class PlaylistLoader {
    
   private let client: Client
   private let session: Session
    
  public init(client: Client, session: Session) {
        self.client = client
        self.session = session
    }

   public func loadPlayList() async throws -> PlayListResponse {
        let request = URLRequest(
            method: .get,
            path: "api/playlist/01GVD0TTY5RRMHH6YMCW7N1H70",
            headers: [
                .contentTypeJson,
                .custom(key: "Authorization", value: "Bearer \(session.token ?? "")")
            ]
        )
      let playListResponse = try await client.load(request, handle: .decoding(to: PlayListResponse.self))
       return playListResponse
    }
    
}


// MARK: - PlayListResponse
public struct PlayListResponse: Codable, Hashable {
    let data: PlaylistData
}

// MARK: - PlaylistDataClass
struct PlaylistData: Codable, Hashable {
    let playlist: Playlist
    let episodes: [Episode]
}

// MARK: - Episode
struct Episode: Codable, Hashable {
    let id: String
    let itunesID: String?
    let type: Int?
    let name, description: String?
    let image, imageBigger: URL?
    let audioLink: URL?
    let duration, durationInSeconds, views: Int?
    let podcastItunesID, podcastName,createdAt: String?
    let releaseDate: String?
    let updatedAt: String?
    let isDeleted: Bool?
    let isEditorPick, sentNotification: Bool?
    let position: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case itunesID = "itunesId"
        case type, name, description, image, imageBigger, audioLink, duration, durationInSeconds, views
        case podcastItunesID = "podcastItunesId"
        case podcastName, releaseDate, createdAt, updatedAt, isDeleted,   isEditorPick, sentNotification, position
    }
    
    var releaseDateArabicString: String {
        guard let releaseDate else {return ""}
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        guard let date = formatter.date(from: releaseDate) else {return ""}
        formatter.locale = Locale(identifier: "ar_DZ")
        formatter.dateFormat = "EEEE, d, MMMM, yyyy HH:mm a"
        let outputDate = formatter.string(from: date)
        return outputDate
    }
}

// MARK: - Playlist
struct Playlist: Codable, Hashable {
    let id: String?
    let type: Int?
    let name, description: String?
    let image: URL?
    let access, status: String?
    let episodeCount, episodeTotalDuration: Int?
    let createdAt, updatedAt: String?
    let isDeleted: Bool?
    let followingCount: Int?
    let userID: String?
    let isSubscribed: Bool?

    enum CodingKeys: String, CodingKey {
        case id, type, name, description, image, access, status, episodeCount, episodeTotalDuration, createdAt, updatedAt, isDeleted, followingCount
        case userID = "userId"
        case isSubscribed
    }
    
    var episodeTotalDurationString: String {
        if let episodeTotalDuration {
            let TotalDuration = secondsToHoursMinutesSeconds(episodeTotalDuration)
            return "\(TotalDuration.0) ساعات" + "\(TotalDuration.1) دقائق" + "\(TotalDuration.2) ثواني"
        }
        return ""
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
