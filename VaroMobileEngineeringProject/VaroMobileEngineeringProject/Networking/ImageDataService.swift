//
//  ImageFetcher.swift
//  VaroMobileEngineeringProject
//
//  Created by Joseph Pecoraro on 8/3/23.
//

import Foundation
import UIKit

actor ImageDataService : NSObject {
    public static let shared = ImageDataService()
    
    private var images : [URL : UIImage] = [:]
    
    private override init() { }
    
    func getImage(url: URL) async -> UIImage? {
        if let image = images[url] {
            return image
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            // TODO: Move magic numbers for image size somewhere central or pass them in
            if let image = UIImage(data: data)?.resize(size: CGSize(width: 150, height: 225)) {
                images[url] = image
                return image
            }
        } catch {
            // TODO: handle error
            print(error)
        }
        
        return nil
    }
}
