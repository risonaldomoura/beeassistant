//
//  BaseChatGPTRepository.swift
//  ChatBotExtension
//
//  Created by Risonaldo Moura on 07/07/23.
//

import Foundation

class BaseChatGPTRepository {
    func fetchApiKey() -> String? {
        let currentBundle = Bundle(for: Self.self)
        
        guard let apiKeyURL = currentBundle.url(forResource: "key", withExtension: "environment"),
              var apiKey = try? String(contentsOf: apiKeyURL, encoding: .utf8)
        else
        {
            return nil
        }
        
        apiKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return apiKey
    }
}
