//
//  DependencyManager.swift
//  ChatBotExtension
//
//  Created by Risonaldo Moura on 07/07/23.
//

import Foundation

final class DependencyManager {
    static func makeExplainCodeDependencies() -> ExplainCodeUseCase {
        let explainCodeRepository: ExplainCodeRepository = ChatGPTExplainCodeRepository()
        let useCase: ExplainCodeUseCase = DefaultExplainCodeUseCase(repository: explainCodeRepository)
        
        return useCase
    }
}
