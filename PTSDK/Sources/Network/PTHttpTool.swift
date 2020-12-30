//
//  PTHttpTool.swift
//  PTPackage
//
//  Created by PainTypeZ on 2020/11/16.
//

import Foundation
import Moya
import SwiftyJSON

public struct PTHttpTool {
    typealias Success<T> = (_ object: T) -> Void
    typealias Failure = (_ errorMessage: String) -> Void
    static var baseURLString: String = ""
    static var signInToken: String = ""
    static var header: [String: String] {
        if !signInToken.isEmpty {
            return ["Content-Type": "application/json", "token": signInToken]
        }
        return ["Content-Type": "application/json"]
    }

    static func request<T: TargetType, M: Codable>(target: T,
                                                   success: @escaping Success<M>,
                                                   failure: @escaping Failure,
                                                   completed: @escaping () -> Void) {
        MoyaProvider<T>().request(target) { result in
            completed()
            switch result {
            case let .success(response):
                do {
                    let model = try JSONDecoder().decode(M.self, from: response.data)
                    success(model)
                } catch let error {
                    failure(error.localizedDescription)
                }
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }

    static func request<T: TargetType, M: JSONable>(target: T,
                                                    success: @escaping Success<M>,
                                                    failure: @escaping Failure,
                                                    completed: @escaping () -> Void) {
        MoyaProvider<T>().request(target) { result in
            completed()
            switch result {
            case let .success(response):
                do {
                    let json = try JSON(data: response.data)
                    let model = M(json)
                    success(model)
                } catch let error {
                    failure(error.localizedDescription)
                }
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }

    static func upload<T: TargetType, M: Codable>(target: T,
                                                  success: @escaping Success<M>,
                                                  failure: @escaping Failure,
                                                  progressCallback: @escaping (ProgressResponse) -> Void) {
         MoyaProvider<T>().request(target, callbackQueue: nil, progress: {
            progressCallback($0)
        }, completion: { result in
            switch result {
            case let .success(response):
                do {
                    let model = try JSONDecoder().decode(M.self, from: response.data)
                    success(model)
                } catch let error {
                    failure(error.localizedDescription)
                }
            case let .failure(failureContent):
                let failureMessage = failureContent.errorDescription
                failure(failureMessage ?? "")
            }
        })
    }

    static func upload<T: TargetType, M: JSONable>(target: T,
                                                   success: @escaping Success<M>,
                                                   failure: @escaping Failure,
                                                   progressCallback: @escaping (ProgressResponse) -> Void) {
         MoyaProvider<T>().request(target, callbackQueue: nil, progress: {
            progressCallback($0)
        }, completion: { result in
            switch result {
            case let .success(response):
                do {
                    let json = try JSON(data: response.data)
                    let model = M(json)
                    success(model)
                } catch let error {
                    failure(error.localizedDescription)
                }
            case let .failure(failureContent):
                let failureMessage = failureContent.errorDescription
                failure(failureMessage ?? "")
            }
        })
    }
}

public protocol JSONable {
    init(_ json: JSON)
}

public extension TargetType {
    var baseURL: URL {
        return URL.init(string: PTHttpTool.baseURLString)!
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String: String]? {
        return PTHttpTool.header
    }
}
