//
//  UserProfileRow.swift
//  NetworkingStudy
//
//  Created by 장은석 on 8/11/25.
//


import SwiftUI

struct UserProfileRow: View {
    
    let user: GitHubUserModel
    
    var body: some View {
        
        HStack {
            
            AsyncImage(url: user.avatarURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                case .failure(_):
                    ProgressView()
                @unknown default:
                    ProgressView()
                }
            }
            .padding(.trailing, 4)
            
            Text(user.login)

            Spacer()
        }
        .frame(height: 60)
        .overlay(
            Rectangle()
                .fill(.gray)
                .opacity(0.2)
                .frame(height: 1)
            , alignment: .bottom
        )
    }
}

#Preview {
    UserProfileRow(user: GitHubUserModel.mockInstance)
}
