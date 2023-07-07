//
//  Constants.swift
//  ChatBotExtension
//
//  Created by Risonaldo Moura on 07/07/23.
//

import Foundation

enum Constants {
    static let baseURL = "https://api.openai.com/v1/chat/completions"
    
    static let contentTypeHeaderKey = "Content-Type"
    static let contentTypeHeaderValue = "application/json"
    
    static let authorizationHeaderKey = "Authorization"
    static let authorizationHeaderValue = "Bearer"
    
    static let modelChatpGPT = "gpt-3.5-turbo"
    static let modelChatGPTUser = "user"
}
