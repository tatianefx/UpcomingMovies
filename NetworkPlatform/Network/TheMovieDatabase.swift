//
//  TheMovieDatabase.swift
//  NetworkPlatform
//
//  Created by Tatiane Souza on 17/11/18.
//  Copyright © 2018 Tatiane Souza. All rights reserved.
//

import Foundation
import Moya

public enum TheMovieDatabase {
    case genres()
    case movies(page: Int?, title: String?, todayDate: String?)
}

extension TheMovieDatabase: TargetType {

    public var baseURL: URL {
        guard let url = URL(string: UrlsHelper.shared.baseUrl) else {
            fatalError("The base url could not be configured")
        }
        return url
    }
    
    public var path: String {
        switch self {
        case .genres:
            return UrlsHelper.shared.genresUrl
        case .movies:
            return UrlsHelper.shared.moviesUrl
        }
    }

    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var parameters: [String : Any]? {
        switch self {
        case .genres():
            return ["api_key": UrlsHelper.shared.apiKey]
        case .movies(let page, let title, let todayDate):
            //TODO Fix search for title
            return ["api_key": UrlsHelper.shared.apiKey,
                    "language": "en-US",
                    "page": page ?? 1,
                    "title": title ?? "",
                    "primary_release_date.gte": todayDate ?? ""]
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.queryString
    }
    
    public var task: Task {
        switch self {
        case .genres, .movies:
            return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
}
