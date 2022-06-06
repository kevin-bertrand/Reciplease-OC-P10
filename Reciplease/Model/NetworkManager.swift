//
//  NetworkManager.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 03/06/2022.
//

import Foundation
import Alamofire

class NetworkManager: NetworkProtocol {
    func request(url: URL, completionHandler: @escaping (DataResponse<RecipesHits, AFError>) -> Void) {
        print("AF")
        let request = AF.request(url) { $0.timeoutInterval = 10 }.validate()
        request.responseDecodable(completionHandler: completionHandler)
    }
}

protocol NetworkProtocol {
    func request(url: URL, completionHandler: @escaping(DataResponse<RecipesHits, AFError>)->Void)
}
