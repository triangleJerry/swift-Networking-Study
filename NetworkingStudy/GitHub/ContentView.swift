//
//  ContentView.swift
//  NetworkingStudy
//
//  Created by 장은석 on 6/2/25.
//

import Foundation
import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var viewModel = GitHubViewModel()
    
    var body: some View {
        
        VStack {
            Text("GitHub User List")
            
            ScrollView {
                
                ForEach(viewModel.gitHubUsers) { user in
                    UserProfileRow(user: user)
                }
            }
        }
        .task {
            viewModel.fetchGitHubUsers()
        }
        
    }
    
    // MARK: - func
}

#Preview {
    ContentView()
}
