//
//  GitHubUserModel.swift
//  NetworkingStudy
//
//  Created by 장은석 on 8/11/25.
//

import Foundation

/// GitHub 사용자 DTO
struct GitHubUserModel: Identifiable, Decodable {
    
    /// GitHub 사용자의 고유 식별자
    let id: Int
    
    /// GitHub 로그인 이름
    let login: String
    
    /// 사용자 프로필 아바타 이미지의 URL
    let avatarURL: URL
    
    enum CodingKeys: String, CodingKey {
        case id, login
        case avatarURL = "avatar_url"
    }
    
    // MARK: - mock
    
    static var mockInstance: GitHubUserModel {
        
        .init(
            id: 1,
            login: "triangleJerry",
            avatarURL: URL(string: "https://avatars.githubusercontent.com/u/184406625?s=96&v=4")!
        )
    }
}
