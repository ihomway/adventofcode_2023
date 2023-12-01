import Algorithms

// MARK: - Day01

struct Day01: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [[String]] {
        data.split(separator: "\n\n").map {
            $0.split(separator: "\n").map(String.init)
        }
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        // Calculate the sum of the first set of input data
        entities.first?
            .map { $0.compactMap(\.wholeNumberValue) }
            .map { $0.twoDigit() }
            .reduce(0, +) ?? 0
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        // Sum the maximum entries in each set of data
        entities.last?
            .map { $0.toInts() }
            .map { $0.twoDigit() }
            .reduce(0, +) ?? 0
    }
}

extension String {
    private static let spelledDigits: [String] = [
        "zero", "one", "two", "three", "four",
        "five", "six", "seven", "eight", "nine"
    ]

    func toInts() -> [Int] {
        var result: [Int] = []
        var remained = ""
        for c in self {
            if let num = c.wholeNumberValue { result.append(num) }
            remained.append(c)
            if let index = Self.spelledDigits.firstIndex(where: { remained.hasSuffix($0) }) {
                result.append(index)
            }
        }

        return result
    }
}

extension [Int] {
    func twoDigit() -> Int {
        guard !isEmpty else { return 0 }
        return self[0] * 10 + self[count - 1]
    }
}
