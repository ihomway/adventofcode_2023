import Algorithms

// MARK: - Day02

struct Day02: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [String] {
        data.split(separator: "\n\n")
            .map(String.init)
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        let loadedCubes: (red: Int, green: Int, blue: Int) = (12, 13, 14)
        let possible: (Game) -> Bool = { isPossible(game: $0, from: loadedCubes) }
        do {
            let result = try parse(content: entities[0])
                .filter(possible)
                .map(\.index)
                .reduce(0, +)
            return String(result)
        } catch {
            print(error)
            return ""
        }
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        do {
            let result = try parse(content: entities[1])
                .map(fewest(game:))
                .map { $0.red * $0.green * $0.blue }
                .reduce(0, +)
            return String(result)
        } catch {
            print(error)
            return ""
        }
    }
}

private func parse(content: String) throws -> [Game] {
    try content
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: "\n")
        .map(parse(line:))
}

typealias Set = (red: Int, green: Int, blue: Int)
typealias Game = (index: Int, sets: [Set])

private func parse(line: String) throws -> Game {
    let c1 = line.trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: ":")
    guard c1.count == 2 else {
        throw Day02Error.invalidData
    }

    let c2 = c1[0].trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
    guard c2.count == 2 else {
        throw Day02Error.invalidData
    }

    guard let index = Int(c2[1]) else { throw Day02Error.invalidData }

    let c3 = c1[1].trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ";")
    let sets = try c3.map {
        let c4 = $0.components(separatedBy: ",")
        var red = 0, green = 0, blue = 0
        for item in c4 {
            let c5 = item.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
            guard c5.count == 2 else { throw Day02Error.invalidData }
            guard let value = Int(c5[0].trimmingCharacters(in: .whitespacesAndNewlines)) else {
                throw Day02Error.invalidData
            }
            switch c5[1].trimmingCharacters(in: .whitespacesAndNewlines) {
            case "red":
                red = value
            case "green":
                green = value
            case "blue":
                blue = value
            default:
                throw Day02Error.invalidData
            }
        }

        return (red, green, blue)
    }

    return (index, sets)
}

private func isPossible(set: Set, from loadedCubes: Set) -> Bool {
    set.red <= loadedCubes.red &&
        set.green <= loadedCubes.green &&
        set.blue <= loadedCubes.blue
}

private func isPossible(game: Game, from loadedCubes: Set) -> Bool {
    let possible: (Set) -> Bool = { isPossible(set: $0, from: loadedCubes) }
    return game.sets.allSatisfy(possible)
}

private func fewest(game: Game) -> Set {
    game.sets.reduce((0, 0, 0)) { (max($0.0, $1.0), max($0.1, $1.1), max($0.2, $1.2)) }
}

// MARK: - Day02Error

enum Day02Error: Error {
    case invalidData
}
