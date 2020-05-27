//
//  RecipeClient.swift
//  Recipiner
//
//  Created by Vanessa on 5/26/20.
//  Copyright © 2020 Vanessa. All rights reserved.
//

import Foundation

public class RecipeClient {
    enum Endpoints {
        static let base = "https://www.themealdb.com/api/json/v1/1/random.php"
            case randomRecipe
        
        var stringValue: String {
            switch self {
                case .randomRecipe:
                    return Endpoints.base
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as! Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    class func getRandomRecipe(completion: @escaping (RecipeDic, Error?) -> Void) {
        print("URL: ", Endpoints.randomRecipe.url.absoluteString)
        taskForGETRequest(url: Endpoints.randomRecipe.url, responseType: RecipeResponse.self) { response, error in
            if let response = response {
                let arr = response.meals[0]
                completion(arr, nil)
            } else {
                completion([:], error)
            }
        }
    }

    class func downloadImage(url: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
}
