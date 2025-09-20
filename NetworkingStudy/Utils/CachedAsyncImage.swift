//
//  CachedAsyncImage.swift
//  NetworkingStudy
//
//  Created by ChatGPT on 3/17/24.
//

import SwiftUI
import UIKit

/// Simple in-memory cache for remote images.
final class MemoryImageCache {
    static let shared = MemoryImageCache()

    private let cache = NSCache<NSURL, UIImage>()

    private init() {
        cache.countLimit = 200
        cache.totalCostLimit = 100 * 1024 * 1024 // ~100 MB cap
    }

    subscript(url: URL) -> UIImage? {
        get { cache.object(forKey: url as NSURL) }
        set {
            if let newValue {
                cache.setObject(newValue, forKey: url as NSURL, cost: newValue.memoryCost)
            } else {
                cache.removeObject(forKey: url as NSURL)
            }
        }
    }

    func removeAll() {
        cache.removeAllObjects()
    }
}

private extension UIImage {
    /// Rough memory cost estimation used by `NSCache` eviction policy.
    var memoryCost: Int {
        guard let cgImage else { return 0 }
        return cgImage.bytesPerRow * cgImage.height
    }
}

/// Async image view backed by `MemoryImageCache`.
struct CachedAsyncImage<Content>: View where Content: View {
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    @StateObject private var loader = Loader()

    init(
        url: URL?,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    var body: some View {
        content(loader.phase)
            .task(id: url) {
                await loader.load(url: url, scale: scale, transaction: transaction)
            }
            .onDisappear {
                loader.cancel()
            }
    }
}

private extension CachedAsyncImage {
    
    @MainActor
    final class Loader: ObservableObject {
        
        @Published private(set) var phase: AsyncImagePhase = .empty

        private var currentTask: Task<Void, Never>?
        private let cache: MemoryImageCache

        init(cache: MemoryImageCache = .shared) {
            self.cache = cache
        }

        func load(url: URL?, scale: CGFloat, transaction: Transaction) async {
            currentTask?.cancel()

            guard let url else {
                phase = .empty
                return
            }

            if let cachedImage = cache[url] {
                apply(transaction) {
                    phase = .success(Image(uiImage: cachedImage))
                }
                return
            }

            phase = .empty

            let task = Task<Void, Never>(priority: .userInitiated) { [weak self, cache] in
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    try Task.checkCancellation()
                    guard let image = UIImage(data: data, scale: scale) else {
                        throw URLError(.cannotDecodeContentData)
                    }
                    cache[url] = image
                    try Task.checkCancellation()
                    await MainActor.run {
                        guard let self else { return }
                        self.apply(transaction) {
                            self.phase = .success(Image(uiImage: image))
                        }
                    }
                } catch {
                    guard !(error is CancellationError) else { return }
                    await MainActor.run {
                        guard let self else { return }
                        self.apply(transaction) {
                            self.phase = .failure(error)
                        }
                    }
                }
            }

            currentTask = task
            await task.value

            if currentTask == task {
                currentTask = nil
            }
        }

        func cancel() {
            currentTask?.cancel()
            currentTask = nil
        }

        private func apply(_ transaction: Transaction, _ updates: () -> Void) {
            if let animation = transaction.animation {
                withAnimation(animation, updates)
            } else {
                updates()
            }
        }
    }
}
