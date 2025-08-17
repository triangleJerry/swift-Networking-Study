//
//  GitHubViewModel.swift
//  NetworkingStudy
//
//  Created by 장은석 on 8/11/25.
//

import SwiftUI

final class GitHubViewModel: ObservableObject {

    @MainActor @Published var gitHubUsers: [GitHubUserModel] = []
    @MainActor @Published var isLoading: Bool = false
    private let networkService = NetworkService()
 
    @MainActor
    func fetchGitHubUsers() async {
        
        isLoading = true
        
        do {
            // GitHub API 호출 (DTO 반환)
            let dto = try await networkService.searchUsers(query: "app", page: "1", perPage: "10")
            gitHubUsers.append(contentsOf: dto)
            isLoading = false
        } catch {
            print("Error:", error)
            isLoading = false
        }
    }
}
