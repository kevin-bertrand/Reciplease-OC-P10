//
//  FakeNetworkManager.swift
//  RecipleaseTests
//
//  Created by Kevin Bertrand on 03/06/2022.
//

import Foundation
import Alamofire
@testable import Reciplease

class FakeNetworkManager: NetworkManager {
    private let _fakeResponse =  FakeResponseData()
    var _status: FakeResponseData.SessionStatus = .correctData
    
    override func request(url: URL, completionHandler: @escaping (DataResponse<RecipesHits, AFError>) -> Void) {
        let result = FakeResponseData.getCorrectData(for: .recipes)
        let urlRequest = URLRequest(url: url)
        let resultat = Alamofire.AFError.responseSerializationFailed(reason: .inputFileNil)
        switch _status {
        case .error, .incorrectData:
            completionHandler(DataResponse(request: urlRequest, response: FakeResponseData.responseData.response, data: FakeResponseData.responseData.data, metrics: .none, serializationDuration: 0, result: .failure(resultat)))
        case .correctData:
            completionHandler((DataResponse(request: urlRequest, response: FakeResponseData.responseData.response, data: FakeResponseData.responseData.data, metrics: .none, serializationDuration: 10, result: .success(result))))
        }
    }
}
