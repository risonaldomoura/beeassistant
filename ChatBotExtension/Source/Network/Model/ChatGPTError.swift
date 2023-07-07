//
//  ChatGPTError.swift
//  ChatBotExtension
//
//  Created by Risonaldo Moura on 07/07/23.
//

import Foundation

enum ChatGPTError: Error {
    case malformedURL(value: String)
    case authentication
    case rateLimitReached
    case serverError
    case unknownServerResponse
    case malformedResponse
}
