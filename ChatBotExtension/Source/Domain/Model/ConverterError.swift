//
//  ConverterError.swift
//  ChatBotExtension
//
//  Created by Risonaldo Moura on 07/07/23.
//

import Foundation

enum ConverterError: Error {
    case emptyResults
    case authorization
    case rateLimit
    case serverStatus
    case unknownResponse
}
