import Algorithms

// MARK: - Day11

struct Day11: AdventDay {
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
        sumOfLenght(of: entities[0], with: 2)
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        sumOfLenght(of: entities[1], with: 1_000_000)
    }

    func sumOfLenght(of data: any StringProtocol, with expansion: Int) -> Int {
        let map = parse(content: data)
        let galaxies: [Point] = map.enumerated().flatMap { y, row in
            row.enumerated().compactMap { x, character -> Point? in
                guard character == "#" else { return nil }
                return Point(x: x, y: y)
            }
        }

        return galaxies
            .allUniquePairs()
            .reduce(0) { result, pair in
                var length = pair.0.length(to: pair.1)

                if pair.0.x != pair.1.x {
                    for i in (min(pair.0.x, pair.1.x) + 1) ..< max(pair.0.x, pair.1.x) {
                        guard map.isColumnEmpty(at: i) else { continue }
                        length += (expansion - 1)
                    }
                }

                if pair.0.y != pair.1.y {
                    for i in (min(pair.0.y, pair.1.y) + 1) ..< max(pair.0.y, pair.1.y) {
                        guard map.isRowEmpty(at: i) else { continue }
                        length += (expansion - 1)
                    }
                }

                return result + length
            }
    }
}

// MARK: - Point

private struct Point: Equatable {
    let x: Int
    let y: Int

    func length(to point: Point) -> Int {
        abs(x - point.x) + abs(y - point.y)
    }
}

private func parse(content: any StringProtocol) -> [[Character]] {
    content.split(separator: "\n")
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .map { $0.map { c in c } }
}

private extension Array {
    func allUniquePairs() -> [(Element, Element)] {
        var pairs: [(Element, Element)] = []
        for (index, first) in enumerated() {
            for second in self[(index + 1)...] {
                pairs.append((first, second))
            }
        }
        return pairs
    }
}

private extension [[Character]] {
    func isRowEmpty(at row: Int) -> Bool {
        self[row].allSatisfy { $0 != "#" }
    }

    func isColumnEmpty(at column: Int) -> Bool {
        self
            .map { $0[column] }
            .allSatisfy { $0 != "#" }
    }
}
