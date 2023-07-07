//
//  ExplainCodeRepository.swift
//  ChatBotExtension
//
//  Created by Risonaldo Moura on 07/07/23.
//

import Foundation

protocol ExplainCodeRepository {
    func explainMeThis(code: String) async throws -> [Suggestion]
}
