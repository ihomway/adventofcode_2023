import Algorithms

// MARK: - Day03

struct Day03: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [String] {
        data.split(separator: "\n\n")
            .map(String.init)
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        let data = parse(content: entities[0])
        return parse(characters: data)
            .map(\.value)
            .reduce(0, +)
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        func inIntersect(from lhs:(Int, Int), to rhs: (Int, Int)) -> Bool {
            (rhs.0 >= lhs.0 - 1 && rhs.0 <= lhs.0 + 1) &&
            (rhs.1 >= lhs.1 - 1 && rhs.1 <= lhs.1 + 1)
        }
        
        let data: [[Character]] = parse(content: entities[0])
        let numbers = parse(characters: data)
        let intersecting: ((Int, Int)) -> [Int] = { input in
            return  numbers.filter { number in
                number.index.contains { loction in inIntersect(from: input, to: loction) }
            }
            .map(\.value)
        }
        
        var result = 0
        for (row, item) in data.enumerated() {
            item.enumerated().forEach { index, character in
                guard character == "*" else { return }
                let numbers = intersecting((row, index))
                if numbers.count < 2 { return }
                result += numbers.reduce(1, *)
            }
        }
        
        return result
    }
}

private func parse(content: String) -> [[Character]] {
    content
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
        .map { $0.map { $0 } }
}

private func parse(characters data: [[Character]]) -> [ParsedValue] {
    func isPositive(position: (Int, Int), data: [[Character]]) -> Bool {
        // left
        if position.1 > 0, data[position.0][position.1 - 1].isSymbolButNotPeriod {
            return true
        }
        // top
        if position.0 > 0, data[position.0 - 1][position.1].isSymbolButNotPeriod {
            return true
        }
        // right
        if position.1 < data[position.0].count - 1, data[position.0][position.1 + 1].isSymbolButNotPeriod {
            return true
        }
        // bottom
        if position.0 < data.count - 1, data[position.0 + 1][position.1].isSymbolButNotPeriod {
            return true
        }
        // left-top
        if position.0 > 0, position.1 > 0, data[position.0 - 1][position.1 - 1].isSymbolButNotPeriod {
            return true
        }
        // right-top
        if position.0 > 0, position.1 < data[position.0].count - 1, data[position.0 - 1][position.1 + 1].isSymbolButNotPeriod {
            return true
        }
        // left-bottom
        if position.0 < data.count - 1, position.1 > 0, data[position.0 + 1][position.1 - 1].isSymbolButNotPeriod {
            return true
        }
        // right-bottom
        if position.0 < data.count - 1, position.1 < data[position.0].count - 1, data[position.0 + 1][position.1 + 1].isSymbolButNotPeriod {
            return true
        }

        return false
    }

    var remainded: [(Int, (Int, Int))] = []
    var validNumbers: [ParsedValue] = []
    var isValid = false

    for (row, item) in data.enumerated() {
        item.enumerated()
            .forEach { index, character in
                guard let number = character.wholeNumberValue else {
                    if isValid {
                        validNumbers.append(
                            .init(
                                index: remainded.reduce(into: []) { $0.append($1.1) },
                                value: remainded.map(\.0).toWholeNumber()
                            )
                        )
                    }
                    isValid = false
                    remainded.removeAll()
                    return
                }
                isValid = isValid || isPositive(position: (row, index), data: data)
                remainded.append((number, (row, index)))
            }
    }

    return validNumbers
}

extension [Int] {
    func toWholeNumber() -> Int {
        guard !isEmpty else { return 0 }
        return reduce(0) { $0 * 10 + $1 }
    }
}

extension Character {
    var isSymbolButNotPeriod: Bool {
        !isNumber && self != "."
    }
}

// MARK: - ParsedValue

private struct ParsedValue {
    let index: [(Int, Int)]
    let value: Int
}
