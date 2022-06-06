//
//  FakeResponseData.swift
//  RecipleaseTests
//
//  Created by Kevin Bertrand on 03/06/2022.
//

import Foundation
import Alamofire
@testable import Reciplease



class FakeResponseData {
    private static let responseOk = HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    private static let responseKO = HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    class ResponseError: Error {} // Protocol not an instance
    static let error = ResponseError()
    
    static func getCorrectData(for url: DataFiles) -> RecipesHits {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: url.rawValue, withExtension: ".json")
        let data = try! Data(contentsOf: url!)
        responseData.data = data
        responseData.error = nil
        responseData.response = responseOk
        let recipes = try! JSONDecoder().decode(RecipesHits.self, from: data)
        return recipes
    }
    
    static var incorrectData: Data {
        get {
            responseData.data = nil
            responseData.response = responseKO
            responseData.error = AFError.explicitlyCancelled
            return "Error".data(using: .utf8)!
        }
    }
    static var responseData = Response()
    
    enum DataFiles: String {
        case recipes = "recipes"
    }
    
    enum SessionStatus {
        case error
        case correctData
        case incorrectData
    }
    
    struct Response {
        var response: HTTPURLResponse?
        var data: Data?
        var error: Error?
    }
}

