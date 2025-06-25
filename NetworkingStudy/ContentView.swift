//
//  ContentView.swift
//  NetworkingStudy
//
//  Created by 장은석 on 6/2/25.
//

import Foundation
import SwiftUI

struct ContentView: View {
    
    /// 각각의 랜덤 이미지 ID들
    @State private var imageIDs: [UUID] = []
    /// 로드된 UIImages (optional)
    @State private var uiImages: [UIImage?] = []
    @State private var isLoading: Bool = false
    
    
    /// 보여줄 이미지 개수
    private let imageCount = 6
    
    /// 그리드 레이아웃 (2열)
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private let networkService = NetworkService()
    
    var body: some View {
        VStack {
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(uiImages.indices, id: \.self) { idx in
                        if let img = uiImages[idx] {
                            Image(uiImage: img)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 150)
                                .clipped()
                                .cornerRadius(8)
                        } else {
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 150)
                                    .cornerRadius(8)
                                ProgressView()
                            }
                        }
                    }
                }
                .padding()
            }
            
            Button("다시 불러오기") {
                Task {
                    await loadImages()
                }
            }
            .disabled(isLoading)
            .padding()
        }
        .task {
            // 초기 UUID 배열 및 빈 이미지 슬롯 세팅
            imageIDs = (0..<imageCount).map { _ in UUID() }
            uiImages = Array(repeating: nil, count: imageCount)
            
            await loadImages()
        }
    }
    
    // MARK: - func
    
    /// UUID 기반 랜덤 URL 생성
    private func url(for id: UUID) -> URL {
        
        URL(string: "https://picsum.photos/300?random=\(id.uuidString)")!
    }
    
    /// 여러 이미지를 병렬로 불러오기
    private func loadImages() async {
        
        isLoading = true
        defer { isLoading = false }
        
        // 새로운 UUID 재생성 (버튼 클릭 시마다 새 이미지)
        imageIDs = (0..<imageCount).map { _ in UUID() }
        uiImages = Array(repeating: nil, count: imageCount)
        
        await withTaskGroup(of: (Int, UIImage?).self) { group in
            for (idx, id) in imageIDs.enumerated() {
                group.addTask {
                    do {
                        let image = try await networkService.fetchImage(from: url(for: id))
                        return (idx, image)
                    } catch {
                        print("Error loading image \(idx):", error)
                        return (idx, nil)
                    }
                }
            }
            
            // 완료된 순서대로 결과 할당
            for await (idx, image) in group {
                uiImages[idx] = image
            }
        }
    }
}

#Preview {
    ContentView()
}
