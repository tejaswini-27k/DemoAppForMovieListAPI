//
//  Service.swift
//  DemoAppForMovieListAPI
//
//  Created by Teasw on 16/12/20.
//

import UIKit

var apiKey = "e5c17300d685426684e82b1945665980"
var baseImageURl = "https://image.tmdb.org/t/p/w200/"
var baseURL = "https://api.themoviedb.org/3/"

class Service: NSObject {

    static var sharedInstance = Service()
    
    func getMovieData(forMovie: String, pageNum: Int , completion: @escaping ( ResultModel?, Error?)->()) {
        let urlString = "\(baseURL)movie/\(forMovie)api_key=\(apiKey)&language=en-US&page=\(pageNum)"
        //https://api.themoviedb.org/3/movie/now_playing?api_key=e5c17300d685426684e82b1945665980&language=en-US&page=1
        guard let url = URL(string: urlString) else {
            return
        }
        print(url)
        fetchMovieList(url: url, completion: completion)
    }
    
    func getSearchMovieDataList(ForString :String , completion: @escaping (ResultModel?, Error?)->()){
        let urlString = "\(baseURL)search/movie?api_key=\(apiKey)&query=" + "\(ForString)"
        guard let url = URL(string: urlString) else {
            return
        }
        print(url)
        fetchMovieList(url: url, completion: completion)
    }

    func fetchMovieList(url: URL, completion: @escaping (ResultModel?, Error?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: url) { (searchData, response, error) in
                if let err = error {
                    completion(nil, err)
                    print(err.localizedDescription)
                } else {
                    guard let data = searchData else {
                        return
                    }
                    do {
                        let result =  try JSONDecoder().decode(ResultModel.self, from: data)
                        completion( result, nil)
                    } catch let jsonError {
                        print(jsonError.localizedDescription)
                        completion(nil,  jsonError)
                    }
                }
            }.resume()
        }
    }
}
