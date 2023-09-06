//
//  MovieModel.swift
//  DemoAppForMovieListAPI
//
//  Created by Teasw on 16/12/20.
//

import Foundation

struct  ResultModel: Decodable  {
    var results = [MovieDetailsModel]()
    var pageNumber : Int?
    var totalPageNum: Int?

    enum CodingKeys : String , CodingKey {
        case results //same json key
        case pageNumber = "page"
        case totalPageNum = "total_pages"
    }
}

struct MovieDetailsModel: Decodable {
    var movieID : Int?
    var movieName : String?
    var movieSynopsis : String?
    var rating : Float?
    var thumbnail : String?
    var releaseDate : String?

    enum CodingKeys : String, CodingKey {
        case movieID = "id"
        case movieName = "title"
        case movieSynopsis = "overview"
        case rating = "vote_average"
        case thumbnail = "poster_path"
        case releaseDate = "release_date"
    }

}
