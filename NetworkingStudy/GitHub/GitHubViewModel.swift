//
//  GitHubViewModel.swift
//  NetworkingStudy
//
//  Created by 장은석 on 8/11/25.
//

import SwiftUI

final class GitHubViewModel: ObservableObject {

    @MainActor @Published var gitHubUsers: [GitHubUserModel] = []
    private let networkService = NetworkService()
 
    func fetchGitHubUsers() async {
        
        do {
            // GitHub API 호출 (DTO 반환)
            let dto = try await networkService.searchUsers(query: "swift", page: "1", perPage: "10")
            await MainActor.run {
                self.gitHubUsers = dto
            }
        } catch {
            print("Error:", error)
        }

    }
}
