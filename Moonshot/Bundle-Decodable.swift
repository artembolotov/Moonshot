//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by artembolotov on 12.01.2023.
//

import Foundation

extension Bundle {
    func decode<T: Codable>(_ filename: String ) -> T {
        guard let url = self.url(forResource: filename, withExtension: nil) else {
            fatalError("Failed to locate \(filename) in bunlde.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(filename) from bundle.")
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(filename) from bundle.")
        }
        
        return loaded
    }
}
