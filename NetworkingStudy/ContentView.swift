//
//  ContentView.swift
//  NetworkingStudy
//
//  Created by 장은석 on 6/2/25.
//

import SwiftUI

struct ContentView: View {
    
    /// imageID를 통해 매번 다른 URL을 생성하여 랜덤 이미지를 가져오기 위한 고유 식별자
    @State private var imageID = UUID()

    /// imageID를 활용해 매번 다른 query parameter를 붙인 URL 생성
    private var imageURL: URL? {
        URL(string: "https://picsum.photos/600?random=\(imageID.uuidString)")
    }

    var body: some View {
        VStack {
            if let url = imageURL {
                
                // URL을 이용해 AsyncImage로 이미지를 비동기 로드
                AsyncImage(url: url) { phase in
                    
                    switch phase {
                    // 이미지 로딩 중인 상태: ProgressView 표시
                    case .empty:
                        ProgressView("Loading Image...")
                            .padding()
                    // 이미지 로드 성공: 화면에 표시
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                    // 이미지 로드 실패: 오류 메시지 표시
                    case .failure:
                        Text("이미지를 불러오지 못했습니다.")
                            .foregroundColor(.red)
                    @unknown default:
                        EmptyView()
                    }
                }
            }

            // 버튼을 눌러 새로운 UUID 할당 -> URL 변경되어 새 이미지 로드
            Button(action: {
                // 새로운 UUID를 할당하여 이미지 URL을 변경, 새로운 이미지를 로드하도록 트리거
                imageID = UUID()
            }) {
                Text("랜덤 이미지 불러오기")
                    .font(.headline)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .task {
            imageID = UUID()
        }
    }
}

#Preview {
    ContentView()
}
