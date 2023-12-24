import Algorithms

struct Day00: AdventDay {
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
        fatalError()
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        fatalError()
    }
}
