//
//  GitHubSearchResponseDTO.swift
//  NetworkingStudy
//
//  Created by 장은석 on 8/11/25.
//

/// GitHub API > Search users DTO
struct GitHubSearchResponseDTO: Decodable {
    
    /// 검색된 GitHub 사용자 DTO 목록
    let items: [GitHubUserModel]
}
