//
//  RamdomUserViewModel.swift
//  NetworkingStudy
//
//  Created by 장은석 on 8/16/25.
//

import SwiftUI

final class RamdomUserViewModel: ObservableObject {

    @MainActor @Published var ramdomUsers: [RamdomUserModel] = []
    @MainActor @Published var isLoading: Bool = false
    private let networkService = NetworkService()
 
    @MainActor
    func fetchRamdomUsers() async {
        
        isLoading = true
        
        do {
            // GitHub API 호출 (DTO 반환)
            let result = try await networkService.searchRamdomUser()
            ramdomUsers.append(contentsOf: result)
            isLoading = false
        } catch {
            print("Error:", error)
            isLoading = false
        }
    }
}
