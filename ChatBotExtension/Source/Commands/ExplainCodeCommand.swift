//
//  ExplainCodeCommand.swift
//  ChatBotExtension
//
//  Created by Risonaldo Moura on 07/07/23.
//

import Foundation
import XcodeKit

final class ExplainCodeCommand: NSObject, XCSourceEditorCommand {
    let useCase: ExplainCodeUseCase = DependencyManager.makeExplainCodeDependencies()
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        Task {
            let fileSourceCode = invocation.buffer.completeBuffer
            
            // 2. Expressão regular para encontrar os comentários relevantes
            let pattern = #"//\s*Bot:\s*(.*)"#
            let regex = try! NSRegularExpression(pattern: pattern)

            // 3. Procure por correspondências nos comentários
            let matches = regex.matches(in: fileSourceCode, range: NSRange(fileSourceCode.startIndex..., in: fileSourceCode))
            print(matches)
            
            invocation.buffer.lines.add("//Carregando resposta...")
            
            for match in matches {
                let range = match.range(at: 1)
                if let commentRange = Range(range, in: fileSourceCode) {
                    let comment = fileSourceCode[commentRange]
                    
                    do {
                        let suggestion = try await self.useCase.explainMeThis(code: String(comment))
                        
                        let insertedExplanation = "/**\n\(suggestion.result)\n*/"
                        
                        invocation.buffer.lines.removeLastObject()
                        invocation.buffer.lines.add(insertedExplanation)
                    } catch let error {
                        print("🚨 Something goes wrong... \(error)")
                    }
                    
                }
            }

            completionHandler(nil)
        }
    }
}
