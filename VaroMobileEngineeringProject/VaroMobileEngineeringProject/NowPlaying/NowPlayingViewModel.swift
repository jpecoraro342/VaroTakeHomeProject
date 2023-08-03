//
//  NowPlayingViewModel.swift
//  VaroMobileEngineeringProject
//
//  Created by Joseph Pecoraro on 8/3/23.
//

import Foundation

class NowPlayingViewModel {
    public var onUpdate : (() -> Void)?
    
    // TODO: Definitely don't use user defaults for this
    private var favorites : Set<String> {
        get {
            return Set(UserDefaults.standard.array(forKey: "favorites") as? [String] ?? [])
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: "favorites")
        }
    }
    
    private var movies : [Movie] = []
    
    public func numberOfItems() -> Int {
        return movies.count
    }
    
    public func getCellViewModel(at indexPath: IndexPath) -> MovieCellViewModel {
        guard indexPath.row < movies.count else {
            print("something really bad happened")
            return MovieCellViewModel(id: "", title: "", posterUrl: Self.basePosterURL, isFavorite: false, toggleFavorite: { _ in })
        }
        
        let movie = movies[indexPath.row]
        
        return MovieCellViewModel(
            id: "\(movie.id)",
            title: movie.title,
            posterUrl: posterURL(posterPath: movie.posterPath),
            isFavorite: favorites.contains("\(movie.id)"),
            toggleFavorite: { self.toggleFavorite(movieId: $0) })
    }

    public func toggleFavorite(movieId: String) {
        var favorites = self.favorites
        if favorites.contains(movieId) {
            favorites.remove(movieId)
        } else {
            favorites.insert(movieId)
        }

        self.favorites = favorites
        self.onUpdate?()
    }
    
    public func updateNowPlaying() {
        Task {
            movies = await MovieDbApiService.shared.fetchNowPlaying()
            onUpdate?()
        }
    }
}

extension NowPlayingViewModel {
    private static let basePosterURL = URL(string: "https://image.tmdb.org/t/p/original")!
    
    private func posterURL(posterPath: String) -> URL {
        return Self.basePosterURL.appending(path: posterPath)
    }
}

struct MovieCellViewModel {
    let id: String
    let title: String
    let posterUrl: URL
    let isFavorite: Bool

    let toggleFavorite: (String) -> Void
}
