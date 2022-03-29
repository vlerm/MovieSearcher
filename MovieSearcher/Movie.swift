//
//  Movie.swift
//  MovieSearcher
//
//  Created by Вадим Лавор on 16.03.22.
//

import Foundation

struct Movie: Codable {
    
    let Title: String
    let Year: String
    let imdbID: String
    let `Type`: String
    let Poster: String
    
}

struct MovieResult: Codable {
    
    let Search: [Movie]
    
}
