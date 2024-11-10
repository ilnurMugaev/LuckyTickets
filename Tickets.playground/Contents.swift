import Foundation

final class Solver {
    
    func run(_ args: [String]) -> String {
        guard let n = Int(args.first ?? "") else { return "Ошибка ввода" }
        return "\(calculateLuckyTickets(n))"
    }
    
    private func calculateLuckyTickets(_ n: Int) -> Int {
        let maxSum = 9 * n
        var dp = Array(repeating: Array(repeating: 0, count: maxSum + 1), count: n + 1)
        dp[0][0] = 1
        
        for digits in 1...n {
            for sum in 0...maxSum {
                for digit in 0...9 where sum >= digit {
                    dp[digits][sum] += dp[digits - 1][sum - digit]
                }
            }
        }
        
        var count = 0
        for sum in 0...maxSum {
            count += dp[n][sum] * dp[n][sum]
        }
        
        return count
    }
}

final class Test {
    
    private let run: ([String]) -> String
    
    init(run: @escaping ([String]) -> String) {
        self.run = run
    }
    
    func runTests() {
        var testIndex = 0
        
        while let (inputContent, outputContent) = loadTestFiles(index: testIndex) {
            let input = inputContent.components(separatedBy: .newlines).filter { !$0.isEmpty }
            let output = outputContent.components(separatedBy: .newlines).filter { !$0.isEmpty }
            
            let result = run(input)
            if result == output.first {
                print("Тест \(testIndex) OK: \(result)")
            } else {
                print("Тест \(testIndex) ошибка: \(result), ожидалось: \(output.first ?? "неизвестно")")
            }
            
            testIndex += 1
        }
    }
    
    private func loadTestFiles(index: Int) -> (String, String)? {
        let fileIn = "test.\(index).in"
        let fileOut = "test.\(index).out"
        
        guard
            let inputContent = load(file: fileIn), !inputContent.isEmpty,
            let outputContent = load(file: fileOut), !outputContent.isEmpty
        else {
            return nil
        }
        
        return (inputContent, outputContent)
    }
    
    private func load(file named: String) -> String? {
        guard let fileUrl = Bundle.main.url(forResource: named, withExtension: "") else {
            return nil
        }
        
        do {
            return try String(contentsOf: fileUrl, encoding: .utf8)
        } catch {
            print("Ошибка при чтении файла \(named): \(error)")
            return nil
        }
    }
}

let solver = Solver()
let test = Test(run: solver.run)
test.runTests()
