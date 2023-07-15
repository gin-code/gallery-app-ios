//
//  NetworkClass.swift
//
//  Created by Sparsh Singh on 23/08/22.
//

import Foundation

final class NetworkClass {
    private init() {}

    static let shared = NetworkClass()

    let decoder = JSONDecoder()

    func apiRequest<T: Codable>(url: String, params: [String: Any], method: String, responseObject _: T.Type, callBack: Callback<T, String>) {
        // Check Internet Connection
        if !Reach.isConnectedToNetwork() {
            print("Internet Not Available.")
            return
        }

        // Convert to URL
        guard let urlComponents = URLComponents(string: url) else { return }

        print("Request URL is:\(urlComponents.url!.absoluteString)")

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method

        // MARK: Headers

        let sessionToken = UserDefaults.standard.string(forKey: "SessionToken") // Check For Token
        let authTokken = UserDefaults.standard.string(forKey: "AuthToken")
        
        if method == "GET" && authTokken != nil {
            request.setValue("\(authTokken ?? "")", forHTTPHeaderField: "Authorization")
            
        } else if sessionToken != nil {
            let headers = ["Authorization": sessionToken] as [String: String?]

            print("Headers \(headers)")
            
            request.allHTTPHeaderFields = headers as? [String: String]
            
        } else {
            let headers = [:] as [String: Any]
            request.allHTTPHeaderFields = headers as? [String: String]
        }

        if method == "POST" || method == "PUT" {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])

        } else {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        
        print(params)
        print("URL: \(urlComponents)")
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 // 30 seconds
        configuration.timeoutIntervalForResource = 30 // 45 seconds
        let session = URLSession(configuration: configuration)
        
        session.dataTask(with: request) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: .utf8)!)
                if let response = response as? HTTPURLResponse, 200 ... 299 ~= response.statusCode {
                    do {
                        let json = try JSONDecoder().decode(T.self, from: data)
                        print("json \(json)")
                        callBack.onSuccess(json)
                    } catch {
                        callBack.onFailure(error.localizedDescription)
                    }
                } else if let response = response as? HTTPURLResponse, 400 ... 499 ~= response.statusCode {
                    do {
                        let json = try JSONDecoder().decode(T.self, from: data)

                        callBack.onSuccess(json)
                    } catch {
                        callBack.onFailure(error.localizedDescription)
                    }

                } else if let response = response as? HTTPURLResponse, 500 ... 599 ~= response.statusCode {
                    callBack.onFailure("Currently having some issue on server, Please try again after some time")
                }
            } else {
                callBack.onFailure(error?.localizedDescription ?? "")
            }
        }.resume()
    }
}
