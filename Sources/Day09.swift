import Algorithms

// MARK: - Day09

struct Day09: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [any StringProtocol] {
        data
            .split(separator: "------------------------------")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        parse(entities[0])
            .map(calculate(_:))
            .reduce(0, +)
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        parse(entities[0])
            .map(calculateV2(_:))
            .reduce(0, +)
    }
}

private func parse(_ content: any StringProtocol) -> [[Int]] {
    content
        .split(separator: "\n")
        .map {
            $0
                .split(separator: " ")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .compactMap(Int.init)
        }
}

private func calculate(_ values: [Int]) -> Int {
    var results: [[Int]] = [values]
    var temp = values
    while !temp.allSatisfy({ $0 == 0 }) {
        let next = temp.adjacentPairs().reduce(into: []) { $0.append($1.1 - $1.0) }
        temp = next
        results.append(next)
    }
    return results.compactMap(\.last).reduce(0, +)
}

private func calculateV2(_ values: [Int]) -> Int {
    var results: [[Int]] = [values]
    var temp = values
    while !temp.allSatisfy({ $0 == 0 }) {
        let next = temp.adjacentPairs().reduce(into: []) { $0.append($1.1 - $1.0) }
        temp = next
        results.append(next)
    }
    return results.compactMap(\.first).reversed().reduce(0) { $1 - $0 }
}
