//
//  RamdomUsersView.swift
//  NetworkingStudy
//
//  Created by 장은석 on 8/17/25.
//


import Foundation
import SwiftUI

struct RamdomUsersView: View {
    
    @StateObject private var viewModel = RamdomUserViewModel()
    
    var body: some View {
        
        Text("Ramdom User List")
        
        ScrollView {
            
            LazyVStack {
                
                ForEach(viewModel.ramdomUsers.indices, id: \.self) { index in
                    
                    let user = viewModel.ramdomUsers[index]
                    RandomUserProfileRow(user: user)
                        .task {
                            if index == viewModel.ramdomUsers.count - 1 && !viewModel.isLoading {
                                await viewModel.fetchRamdomUsers()
                            }
                        }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
        .padding()
        .ignoresSafeArea()
        .task {
            await viewModel.fetchRamdomUsers()
        }
    }
    
    // MARK: - func
}

#Preview {
    RamdomUsersView()
}
