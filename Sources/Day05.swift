import Algorithms

// MARK: - Day05

struct Day05: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [String] {
        data.split(separator: "------------------------------")
            .map(String.init)
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        let c1 = entities[0].split(separator: "\n\n")
        let seeds = parseSeeds(content: c1[0])
        let maps = c1[1...].map(parseMap(content:))
        
        return seeds
            .map { seed in maps.reduce(seed, { $1($0) }) }
            .min()!
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        let c1 = entities[1].split(separator: "\n\n")
        let seeds = parseSeedsV2(content: c1[0])
        let maps = c1[1...].map(parseMap(content:))
        
        return seeds
            .map { seed in maps.reduce(seed, { $1($0) }) }
            .min()!
    }
}


private func parseSeeds(content: Substring) -> [Int] {
    content
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .split(separator: " ")
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .compactMap(Int.init)
}

private func parseSeedsV2(content: Substring) -> [Int] {
    let pairs = content
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .split(separator: " ")
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .compactMap(Int.init)
    
    var result: [Int] = []
    for pair in pairs.chunks(ofCount: 2) {
        result.append(contentsOf: pair[pair.startIndex]..<(pair[pair.startIndex] + pair[pair.index(after: pair.startIndex)]))
    }
    return result
}

func parseMap(content: Substring) -> (Int) -> (Int) {
    func parse(line: Substring) -> (range: Range<Int>, addition: Int) {
        let c1 = line
            .split(separator: " ")
            .map(String.init)
            .compactMap(Int.init)
        guard c1.count == 3 else { fatalError() }
        return (c1[1]..<(c1[1] + c1[2]), c1[0] - c1[1])
    }
    
    let conditions = content
        .split(separator: "\n")
        .dropFirst()
        .map(parse(line:))
    return { input in
        for condition in conditions {
            if condition.range.contains(input) { return input + condition.addition }
        }
        return input
    }
}
