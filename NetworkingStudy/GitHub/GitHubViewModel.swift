//
//  GitHubViewModel.swift
//  NetworkingStudy
//
//  Created by 장은석 on 8/11/25.
//

import SwiftUI

@MainActor
final class GitHubViewModel: ObservableObject {

    @Published var gitHubUsers: [GitHubUserModel] = []
    private let networkService = NetworkService()
 
    func fetchGitHubUsers() {
        
        Task { [weak self] in
            
            guard let self else {
                return
            }
            
            do {
                // GitHub API 호출 (DTO 반환)
                let dto = try await networkService.searchUsers(query: "swift", page: "1", perPage: "10")
                self.gitHubUsers = dto
            } catch {
                print("Error:", error)
            }
        }
    }
}
