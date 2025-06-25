//
//  NetworkService.swift
//  NetworkingStudy
//
//  Created by 장은석 on 6/11/25.
//

import SwiftUI
import UIKit

protocol NetworkServiceProtocol {
    
    func fetchImage(from url: URL) async throws -> UIImage?
}

class NetworkService: NetworkServiceProtocol {
    
    private let session: URLSession

    init(session: URLSession = .shared) {
        
        self.session = session
    }
    
    /// Fetches and returns a UIImage from the specified URL using async/await.
    func fetchImage(from url: URL) async throws -> UIImage? {
        // Perform the network request
        let (data, _) = try await session.data(from: url)
        // Convert Data to UIImage
        return UIImage(data: data)
    }
}
