//
//  NetworkService.swift
//  NetworkingStudy
//
//  Created by 장은석 on 6/11/25.
//

import SwiftUI

class NetworkService {
    
    /// 사용자 검색
    func searchUsers(query: String, page: String, perPage: String) async throws -> [GitHubUserModel] {
        
        var components = URLComponents(string: "https://api.github.com/search/users")
        components?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "per_page", value: perPage),
            URLQueryItem(name: "page", value: page)
        ]
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        print("hhh \(url)")
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(GitHubSearchResponseDTO.self, from: data)
            return decodedData.items
        } catch {
            throw URLError(.badURL)
        }
    }
}
