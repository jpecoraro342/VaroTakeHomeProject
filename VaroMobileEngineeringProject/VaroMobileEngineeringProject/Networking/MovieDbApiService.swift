//
//  MovieDbApi.swift
//  VaroMobileEngineeringProject
//
//  Created by Joseph Pecoraro on 8/3/23.
//

import Foundation

class MovieDbApiService {
    static let APIKey = "7bfe007798875393b05c5aa1ba26323e"
    static let nowPlayingURL = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
    
    let decoder : JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }()
    
    public static let shared = MovieDbApiService()
    
    private init() { }
    
    private func getURLRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: urlWithApiKey(url: url))
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    private func urlWithApiKey(url: URL) -> URL {
        return url.appending("api_key", value: Self.APIKey)
    }
}

extension MovieDbApiService {
    public func fetchNowPlaying() async -> [Movie] {
        do {
            let (data, _) = try await URLSession.shared.data(for: getURLRequest(url: Self.nowPlayingURL))
            
            let jsonData = try decoder.decode(NowPlaying.self, from: data)
            
            return jsonData.results
        }
        catch {
            print(error)
            return []
        }
    }
}

struct NowPlaying : Codable {
    //    let page : Int
    let results : [Movie]
}

struct Movie : Codable {
    let id : Int
    let title : String
    let posterPath : String
    //    let voteAverage : Double
    //    let releaseDate : String // TODO: Date
}
