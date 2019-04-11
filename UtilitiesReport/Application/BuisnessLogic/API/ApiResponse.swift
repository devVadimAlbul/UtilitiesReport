//
//  ApiResponse.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/28/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation


struct ApiParseError: Error {
    static let code = 999
    
    let error: Error
    let httpUrlResponse: HTTPURLResponse
    let data: Data?
    
    var localizedDescription: String {
        return error.localizedDescription
    }
}

enum ApiError {
    case networkError(Error)
    case dataNotFound
    case networkRequestError(Error?)
}

extension ApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return error.localizedDescription
        case .dataNotFound:
            return "Not found data by request"
        case .networkRequestError(let error):
            return error?.localizedDescription ?? "Network request error - no other information"
        }
    }
}

struct NetworkApiError: Error {
    let data: Data?
    let httpUrlResponse: HTTPURLResponse
}

struct ApiResponse<Response> {
    let entity: Response
    let httpUrlResponse: HTTPURLResponse
    let data: Data?
    private var decode: (Data?) throws -> Response
    
    init(data: Data?, httpUrlResponse: HTTPURLResponse,
         decode: @escaping ((Data?) throws -> Response)) throws {
        self.httpUrlResponse = httpUrlResponse
        self.data = data
        self.decode = decode
        do {
            self.entity = try decode(data)
        } catch {
            throw ApiParseError(error: error, httpUrlResponse: httpUrlResponse, data: data)
        }
    }
}

func defaultJsonDecode<T: Decodable>(_ data: Data?) throws -> T {
    guard let rData = data else {
        throw ApiError.dataNotFound
    }
    return try JSONDecoder().decode(T.self, from: rData)
}

extension ApiResponse where Response: Decodable {
    
    init(data: Data?, httpUrlResponse: HTTPURLResponse) throws {
        try self.init(data: data, httpUrlResponse: httpUrlResponse, decode: defaultJsonDecode)
    }
}

extension ApiResponse where Response == Data {
    
    init(data: Data?, httpUrlResponse: HTTPURLResponse) throws {
        try self.init(data: data, httpUrlResponse: httpUrlResponse, decode: { data in
            guard let rData = data else {
                throw ApiError.dataNotFound
            }
            return rData
        })
    }
}

extension ApiResponse where Response == String {
    
    init(data: Data?, httpUrlResponse: HTTPURLResponse) throws {
        try self.init(data: data, httpUrlResponse: httpUrlResponse, decode: { data in
            guard let rData = data else {
                throw ApiError.dataNotFound
            }
            return String(decoding: rData, as: UTF8.self)
        })
    }
}

extension ApiResponse where Response == Void {
    
    init(data: Data?, httpUrlResponse: HTTPURLResponse) throws {
        try self.init(data: data, httpUrlResponse: httpUrlResponse, decode: {_ in () })
    }
}
