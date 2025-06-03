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
    @State private var uiImage: UIImage? = nil
    @State private var isLoading: Bool = false

    var body: some View {
        
        VStack {
            
            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .opacity(isLoading ? 0.5 : 1)
                    .overlay(
                        Group {
                            if isLoading {
                                ProgressView("Loading Image...")
                                    .padding()
                            }
                        }
                    )
            }

            // 버튼을 눌러 새로운 UUID 할당 -> URL 변경되어 새 이미지 로드
            Button(action: {
                imageID = UUID()
                Task {
                    await loadImage()
                }
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
            await loadImage()
        }
    }
    
    /// imageID를 활용해 매번 다른 query parameter를 붙인 URL 생성
    private var imageURL: URL? {
        
        URL(string: "https://picsum.photos/600?random=\(imageID.uuidString)")
    }
    
    private func loadImage() async {
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        guard let url = imageURL else {
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let fetchedImage = UIImage(data: data) {
                uiImage = fetchedImage
            }
        } catch {
            print("Error fetching image: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
