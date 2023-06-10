import Foundation

public struct BeeAssistant {
    public private(set) var text = "Hello, World!"

    public init() {
        // 1. Abra o arquivo de código-fonte para leitura
        guard let sourceFile = CommandLine.arguments.dropFirst().first else {
            print("Por favor, especifique o arquivo de código-fonte como argumento.")
            exit(1)
        }

        let fileURL = URL(fileURLWithPath: sourceFile)
        guard let sourceCode = try? String(contentsOf: fileURL) else {
            print("Não foi possível ler o arquivo de código-fonte.")
            exit(1)
        }

        // 2. Defina a expressão regular para encontrar os comentários relevantes
        let pattern = #"//\s*Request:\s*(.*)"#
        let regex = try! NSRegularExpression(pattern: pattern)

        // 3. Procure por correspondências nos comentários
        let matches = regex.matches(in: sourceCode, range: NSRange(sourceCode.startIndex..., in: sourceCode))
        print(matches)
        // 4. Processar as correspondências e gerar o método de exemplo
        for match in matches {
            let range = match.range(at: 1)
            if let commentRange = Range(range, in: sourceCode) {
                let comment = sourceCode[commentRange]

                print(comment)

                // 5. Extraia as informações relevantes do comentário (por exemplo, URL da requisição)
                let requestURL = String(comment)
                
                // 6. Gere o código do método de exemplo com base nas informações extraídas
                let exampleMethod = """
                func makeHTTPRequest() {
                    // Exemplo de método que faz uma requisição HTTP para: \(requestURL)
                    // Implemente a lógica aqui...
                }
                """
                
                // 7. Adicione o código gerado ao arquivo de código-fonte existente
                let newSourceCode = sourceCode.replacingCharacters(in: commentRange, with: exampleMethod)
                
                // 8. Salve o novo código-fonte de volta ao arquivo
                try? newSourceCode.write(to: fileURL, atomically: true, encoding: .utf8)
                
                print("Método de exemplo gerado com sucesso para o comentário: \(comment)")
            }
        }

        print("Processo concluído!")
    }
    
    public func executeScript(filePath: String) {
            let scriptURL = URL(fileURLWithPath: "./generate.swift")
            let sourceFilePath = filePath
            
            // Verifique se o script existe no caminho especificado
            guard FileManager.default.fileExists(atPath: scriptURL.path) else {
                print("O script não foi encontrado.")
                return
            }
            
            // Crie um processo para executar o script
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
            process.arguments = ["swift", scriptURL.path, sourceFilePath]
            
            // Configure as tubulações para capturar a saída do processo
            let pipe = Pipe()
            process.standardOutput = pipe
            
            // Execute o script
            do {
                try process.run()
                print("Executando o script")
                
                // Aguarde o término do script e obtenha a saída
                process.waitUntilExit()
                
                print("Lendo a saída do script")
                
                // Leia a saída do processo
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8) {
                    print(output)
                }
            } catch {
                print("Ocorreu um erro ao executar o script:", error.localizedDescription)
            }
        }
}
