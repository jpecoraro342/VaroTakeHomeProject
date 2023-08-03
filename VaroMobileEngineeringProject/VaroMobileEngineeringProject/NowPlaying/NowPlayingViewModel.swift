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

    private var filteredMovies : [Movie] = []

    private var isFiltered : Bool = false

    public var filterTitle : String {
        get {
            return isFiltered ? "Show All" : "Filter Favorites"
        }
    }
    
    public func numberOfItems() -> Int {
        return isFiltered ? filteredMovies.count : movies.count
    }
    
    public func getCellViewModel(at indexPath: IndexPath) -> MovieCellViewModel {
        let movie = isFiltered ? filteredMovies[indexPath.row] : movies[indexPath.row]
        
        return MovieCellViewModel(
            id: "\(movie.id)",
            title: movie.title,
            posterUrl: posterURL(posterPath: movie.posterPath),
            isFavorite: favorites.contains("\(movie.id)"),
            toggleFavorite: { self.toggleFavorite(movieId: $0) })
    }

    private func toggleFavorite(movieId: String) {
        var favorites = self.favorites
        if favorites.contains(movieId) {
            favorites.remove(movieId)
        } else {
            favorites.insert(movieId)
        }

        self.favorites = favorites
        self.updateFiltered()
        self.onUpdate?()
    }
    
    public func updateNowPlaying() {
        Task {
            movies = await MovieDbApiService.shared.fetchNowPlaying()
            onUpdate?()
        }
    }

    public func toggleFilterFavorites() {
        isFiltered = !isFiltered
        updateFiltered()
        onUpdate?()
    }

    private func updateFiltered() {
        filteredMovies = movies.filter({ favorites.contains("\($0.id)") })
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
