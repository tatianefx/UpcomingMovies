//
//  UrlsHelper.swift
//  NetworkPlatform
//
//  Created by Tatiane Souza on 17/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation

final class UrlsHelper {
    
    static let shared = UrlsHelper()
    
    // MARK: - Init
    private init() { }
    
    var apiKey: String {
        return "1f54bd990f1cdfb230adb312546d765d"
    }
    
    var baseUrl: String {
        return "https://api.themoviedb.org/3/"
    }
    
    var moviesUrl: String {
        return "movie/upcoming"
    }
    
    var genresUrl: String {
        return "genre/movie/list"
    }
    
    var searchUrl: String {
        return "search/movie"
    }
    
}
