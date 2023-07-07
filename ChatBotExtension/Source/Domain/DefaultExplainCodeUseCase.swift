//
//  DefaultExplainCodeUseCase.swift
//  ChatBotExtension
//
//  Created by Risonaldo Moura on 07/07/23.
//

import Foundation

final class DefaultExplainCodeUseCase: ExplainCodeUseCase {
    private let repository: ExplainCodeRepository
    
    init(repository: ExplainCodeRepository) {
        self.repository = repository
    }
    
    func explainMeThis(code: String) async throws -> Suggestion {
        let suggestions = try await self.repository.explainMeThis(code: code)
        
        guard let suggestion = suggestions.first else {
            throw ConverterError.emptyResults
        }
        
        return suggestion
    }
}
