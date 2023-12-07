import Algorithms

// MARK: - Day07

struct Day07: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [any StringProtocol] {
        data.split(separator: "------------------------------")
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        let handtype: (([Character], Int)) -> (HandType, Int) = { (parseHandType($0.0), $0.1) }
        let valueForCharacter: (Character) -> Int = { value($0, 11) }
        let compare: (HandType, HandType) -> Bool = { compareHandType($0, $1, valueForCharacter) }
        return entities[0]
            .split(separator: "\n")
            .map(parse(_:))
            .map(handtype)
            .sorted(by: { compare($0.0, $1.0) })
            .enumerated()
            .reduce(0) { $0 + ($1.offset + 1) * $1.element.1 }
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        let handtype: (([Character], Int)) -> (HandType, Int) = { (parseHandType($0.0, "J"), $0.1) }
        let valueForCharacter: (Character) -> Int = { value($0, -11) }
        let compare: (HandType, HandType) -> Bool = { compareHandType($0, $1, valueForCharacter) }
        return entities[0]
            .split(separator: "\n")
            .map(parse(_:))
            .map(handtype)
            .sorted(by: { compare($0.0, $1.0) })
            .enumerated()
            .reduce(0) { $0 + ($1.offset + 1) * $1.element.1 }
    }
}

// MARK: - HandType

private enum HandType {
    case fiveOfAKind([Character])
    case fourOfAKind([Character])
    case fullHouse([Character])
    case threeOfAKind([Character])
    case twoPair([Character])
    case onePair([Character])
    case highCard([Character])
}

private func value(
    _ character: Character,
    _ valueForJ: Int
) -> Int {
    if let number = character.wholeNumberValue { return number }
    switch character {
    case "A": return 14
    case "K": return 13
    case "Q": return 12
    case "J": return valueForJ
    case "T": return 10
    default: fatalError()
    }
}

private func parse(
    _ content: any StringProtocol
) -> ([Character], Int) {
    let c1 = content.split(separator: " ")
    guard c1.count == 2, let bids = Int(String(c1[1])) else {
        fatalError("Invalid line: \(content)")
    }
    return (c1[0].map { $0 }, bids)
}

private func parseHandType(
    _ cards: [Character],
    _ jocker: Character? = nil
) -> HandType {
    let group = cards.grouped(by: { $0 }).values
    if group.count == 1 {
        return .fiveOfAKind(cards)
    }
    if group.count == 2 {
        // [xxxx],[#]
        if group.contains(where: { $0.count == 4 }) {
            if let jocker, group.contains(where: { $0.contains(jocker) }) {
                return .fiveOfAKind(cards)
            }
            return .fourOfAKind(cards)
        }
        // [xxx],[##]
        if let jocker, group.contains(where: { $0.contains(jocker) }) {
            return .fiveOfAKind(cards)
        }
        return .fullHouse(cards)
    }
    if group.count == 3 {
        // [xxx],[#][*]
        if group.contains(where: { $0.count == 3 }) {
            if let jocker, group.contains(where: { $0.contains(jocker) }) {
                return .fourOfAKind(cards)
            }
            return .threeOfAKind(cards)
        }
        // [xx],[##][*]
        if let jocker, group.contains(where: { $0.count == 1 && $0.contains(jocker) }) {
            return .fullHouse(cards)
        }
        if let jocker, group.contains(where: { $0.count == 2 && $0.contains(jocker) }) {
            return .fourOfAKind(cards)
        }
        return .twoPair(cards)
    }
    // [xx],[#],[*],[@]
    if group.count == 4 {
        if let jocker, group.contains(where: { $0.contains(jocker) }) {
            return .threeOfAKind(cards)
        }
        return .onePair(cards)
    }

    if let jocker, group.contains(where: { $0.contains(jocker) }) {
        return .onePair(cards)
    }

    return .highCard(cards)
}

private func compareHandType(
    _ lhs: HandType,
    _ rhs: HandType,
    _ value: (Character) -> Int
) -> Bool {
    func compare(
        lhs: [Character],
        rhs: [Character]
    ) -> Bool {
        for pair in zip(lhs, rhs) {
            if value(pair.0) == value(pair.1) { continue }
            return value(pair.0) < value(pair.1)
        }
        return false
    }

    switch (lhs, rhs) {
    case let (.fiveOfAKind(l), .fiveOfAKind(r)):
        return compare(lhs: l, rhs: r)
    case (.fiveOfAKind, _):
        return false
    case (_, .fiveOfAKind):
        return true
    case let (.fourOfAKind(l), .fourOfAKind(r)):
        return compare(lhs: l, rhs: r)
    case (.fourOfAKind, _):
        return false
    case (_, .fourOfAKind):
        return true
    case let (.fullHouse(l), .fullHouse(r)):
        return compare(lhs: l, rhs: r)
    case (.fullHouse, _):
        return false
    case (_, .fullHouse):
        return true
    case let (.threeOfAKind(l), .threeOfAKind(r)):
        return compare(lhs: l, rhs: r)
    case (.threeOfAKind, _):
        return false
    case (_, .threeOfAKind):
        return true
    case let (.twoPair(l), .twoPair(r)):
        return compare(lhs: l, rhs: r)
    case (.twoPair, _):
        return false
    case (_, .twoPair):
        return true
    case let (.onePair(l), .onePair(r)):
        return compare(lhs: l, rhs: r)
    case (.onePair, _):
        return false
    case (_, .onePair):
        return true
    case let (.highCard(l), .highCard(r)):
        return compare(lhs: l, rhs: r)
    }
}
