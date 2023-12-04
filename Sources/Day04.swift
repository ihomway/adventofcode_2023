import Algorithms
import Foundation

// MARK: - Day04

struct Day04: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [String] {
        data.split(separator: "\n\n")
            .map(String.init)
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        entities[0]
            .components(separatedBy: "\n")
            .compactMap(Card.init(content:))
            .map(\.score)
            .reduce(0, +)
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        let cards = entities[0]
            .components(separatedBy: "\n")
            .compactMap(Card.init(content:))
        var scratchcards = Array(repeating: 1, count: cards.count)
        for (index, card) in cards.enumerated() {
            print(card.winedScratchcards)
            guard index < cards.count - 1, card.winedScratchcards > 0 else { continue }
            for innerIndex in (index+1)...(min(index+card.winedScratchcards, cards.count - 1)) {
                scratchcards[innerIndex] += scratchcards[index]
            }
            print(scratchcards)
        }

        return scratchcards.reduce(0, +)
    }
}

// MARK: - Card

private struct Card {
    // MARK: Lifecycle

    init?(content: String) {
        func numbers(from text: String) -> [Int] {
            text
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: " ")
                .compactMap {
                    Int($0.trimmingCharacters(in: .whitespacesAndNewlines))
                }
        }

        let c1 = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ":")
        guard c1.count == 2 else { return nil }

        let c2 = c1[1].trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "|")
        guard c2.count == 2 else { return nil }

        name = c1[0].trimmingCharacters(in: .whitespacesAndNewlines)
        winning = numbers(from: c2[0])
        self.numbers = numbers(from: c2[1])
    }

    // MARK: Internal

    let name: String
    let winning: [Int]
    let numbers: [Int]

    var winedScratchcards: Int { numbers.filter { winning.contains($0) }.count }

    var score: Int {
        Int(pow(2 as Double, Double(winedScratchcards - 1)))
    }
}
