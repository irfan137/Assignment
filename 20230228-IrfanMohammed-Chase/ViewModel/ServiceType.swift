//
//  ServiceType.swift
//  20230228-IrfanMohammed-Chase
//
//  Created by Irfan Mohammed on 2/28/23.
//

import Foundation

struct SuccessResponse<T> {
    let modelObject: T
    let statusCode: Int
}

struct ErrorResponse {
    let error: Error
    let statusCode: Int
    let networkError: Bool
}

enum WeatherResult<Success> {
    case success(SuccessResponse<Success>)
    case failure(ErrorResponse)
}
