//
//  OpenAI.swift
//  ChatBotExtension
//
//  Created by Risonaldo Moura on 07/07/23.
//

import Foundation

final class OpenAI {
    private let apiKey: String
    private let commonHeaders: [String : String]
    
    init(key: String) {
        self.apiKey = key
        
        self.commonHeaders = [
            Constants.contentTypeHeaderKey : Constants.contentTypeHeaderValue,
            Constants.authorizationHeaderKey : "\(Constants.authorizationHeaderValue) \(key)"
        ]
    }
    
    internal func processRequestFor(prompt: String) async throws -> ChatGPTResponse {
        let chatGRTRequest = ChatGPTRequest(prompt: prompt)
        let data = try? JSONEncoder().encode(chatGRTRequest)
        
        let request = NetworkRequest(httpHeaders: commonHeaders, body: data)
        
        guard let openaiURLRequest = request.makeURLRequest(for: Constants.baseURL) else {
            throw ChatGPTError.malformedURL(value: Constants.baseURL)
        }
        
        guard let (data, response) = try? await URLSession.shared.data(for: openaiURLRequest),
              let httpResponse = response as? HTTPURLResponse
        else
        {
            throw ChatGPTError.unknownServerResponse
        }
        
        switch httpResponse.statusCode {
            case 401:
                throw ChatGPTError.authentication
            case 429:
                throw ChatGPTError.rateLimitReached
            case 500:
                throw ChatGPTError.serverError
            case 200:
                let chatGPTResponse = try self.processResponse(data: data)
                return chatGPTResponse
            default:
                throw ChatGPTError.unknownServerResponse
        }
    }
    
    private func processResponse(data: Data) throws -> ChatGPTResponse {
        let jsonDecoder = JSONDecoder()
        
        do {
            let chatGPTResponse = try jsonDecoder.decode(ChatGPTResponse.self, from: data)
            return chatGPTResponse
        } catch {
            throw ChatGPTError.malformedResponse
        }
    }
}

extension OpenAI {

    func explain(source code: String) async throws -> ChatGPTResponse {
        let explainPrompt = "\(localizedPrompt("PROMPT_EXPLAIN_CODE")) \(code)"
        
        return try await processRequestFor(prompt: explainPrompt)
    }
}

extension OpenAI {
    func localizedPrompt(_ key: String) -> String {
        let openAIBundle = Bundle(for: Self.self)
        
        return NSLocalizedString(key, bundle: openAIBundle, comment: "")
    }
}
