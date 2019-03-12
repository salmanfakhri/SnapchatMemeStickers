//
//  APIService.swift
//  SnapKitHack
//
//  Created by Salman Fakhri on 3/10/19.
//  Copyright © 2019 Salman Fakhri. All rights reserved.
//

import Foundation

class APIService {
    
    private static let sharedService: APIService = {
       return APIService()
    }()
    
    func getMemes(completion: @escaping ([RedditResponse.RedditResponseData.Child])->()) {
        guard let url = URL(string: "https://www.reddit.com/r/wholesomememes/top/.json?count=20") else { return }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: request) { (data, res, error) in
            if let error = error {
                print(error)
                return
            }
            if let responseData = data {
                let decoder = JSONDecoder()
                do {
                    let parsed = try decoder.decode(RedditResponse.self, from: responseData)
                    completion(parsed.data.children)
                } catch {
                    print(error)
                }
            } else {
                print("no response data")
            }
        }
        task.resume()
        
    }
    
    class func shared() -> APIService {
        return sharedService
    }
}
