import Algorithms
import Foundation

// MARK: - Day06

struct Day06: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [any StringProtocol] {
        data.split(separator: "------------------------------")
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        parse(content: entities[0])
            .map(countOfWaysToWin(input:))
            .reduce(1, *)
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        parseV2(content: entities[1])
            .map(countOfWaysToWin(input:))
            .reduce(1, *)
    }
}

private func parse(content: any StringProtocol) -> Zip2Sequence<[Int], [Int]> {
    let c1 = content
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .split(separator: "\n")
    guard c1.count == 2 else { fatalError() }
    let c2 = c1.map { $0.split(separator: " ").dropFirst() }

    return zip(
        c2[0].map(String.init).compactMap(Int.init),
        c2[1].map(String.init).compactMap(Int.init)
    )
}

private func parseV2(content: any StringProtocol) -> any Collection<(Int, Int)> {
    let c1 = content
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .split(separator: "\n")
        .map { $0.split(separator: " ") }
        .map { $0.dropFirst().joined(separator: "") }
        .compactMap(Int.init)

    return CollectionOfOne((c1[0], c1[1]))
}

private func countOfWaysToWin(input: (time: Int, distance: Int)) -> Int {
    // (time - n) * n > distance
    // time * n - n^2 > distance
    // -n^2 + time * n - distance > 0
    // n^2 - time * n + distance < 0
    // (time +/- sqrt(time^2 - 4 * 1 * (distance))) / (2 *　１)
    // (time +/- sqrt(time^2 - 4 * (distance))) / 2
    let (time, distance) = input
    let delta = sqrt(pow(Double(time), 2) - 4 * Double(distance))
    let x_1 = (Double(time) + delta) / 2
    let x_2 = (Double(time) - delta) / 2
    return ((Int(floor(min(x_1, x_2))) + 1) ..< Int(ceil(max(x_1, x_2)))).count
}
