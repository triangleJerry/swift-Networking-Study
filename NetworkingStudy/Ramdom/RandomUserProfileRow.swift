//
//  RandomUserProfileRow.swift
//  NetworkingStudy
//
//  Created by 장은석 on 8/16/25.
//

import SwiftUI

struct RandomUserProfileRow: View {

    let user: RamdomUserModel
    
    var body: some View {
        
        HStack {
            
            CachedAsyncImage(url: URL(string: user.picture.thumbnail)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                case .failure(_):
                    ProgressView()
                @unknown default:
                    ProgressView()
                }
            }
            .padding(.trailing, 4)
            
            Text(user.name.title)

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
    RandomUserProfileRow(user: RamdomUserModel(name: Name(title: "hi", first: "first", last: "last"), email: "", picture: Picture(large: "", medium: "", thumbnail: "https://randomuser.me/api/portraits/thumb/women/32.jpg")))
}
