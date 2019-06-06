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
    case dataNotParse
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
        case .dataNotParse:
            return "Data not parsing by request."
        }
    }
}

struct NetworkApiError: Error {
    let data: Data?
    let httpUrlResponse: HTTPURLResponse
}

struct VoidResponse: Decodable {
    
}

struct HTMLCodeResponse: Decodable {
    var content: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        content = try container.decode(String.self)
    }
}

struct ApiResponse<Response: Decodable> {
    let entity: Response
    let httpUrlResponse: HTTPURLResponse
    let data: Data?
    
    init(data: Data?, httpUrlResponse: HTTPURLResponse) throws {
        self.data = data
        self.httpUrlResponse = httpUrlResponse
        guard let data = data else {
            throw ApiError.dataNotFound
        }
        do {
            self.entity = try JSONDecoder().decode(Response.self, from: data)
        } catch {
            throw ApiParseError(error: error, httpUrlResponse: httpUrlResponse, data: data)
        }
    }
}
