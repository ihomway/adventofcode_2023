import Algorithms

// MARK: - Day08

struct Day08: AdventDay {
    // MARK: Internal

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
        let instruction = parse(entities[0])
        return run(initialLabel: "AAA", stop: { $0 == "ZZZ" }, steps: instruction.steps, maps: instruction.maps)
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        let instruction = parse(entities[1])
        let labels: [String] = instruction.maps.keys.filter { $0.hasSuffix("A") }
        let _run: (String) -> Int = {
            run(initialLabel: $0, stop: { $0.hasSuffix("Z") }, steps: instruction.steps, maps: instruction.maps)
        }
        return labels
            .map(_run)
            .reduce(1, lcm)
    }

    // MARK: Private

    private func run(initialLabel: String, stop: @escaping (String) -> Bool, steps: [Character], maps: [String: (String, String)]) -> Int {
        var label = initialLabel
        var count = 0
        while !stop(label) {
            for step in steps {
                count += 1
                guard let nextStep = maps[label] else { fatalError() }
                label = step == "L" ? nextStep.0 : nextStep.1
                if stop(label) { break }
            }
        }
        return count
    }
}

private func parse(_ content: any StringProtocol) -> (steps: [Character], maps: [String: (String, String)]) {
    let c1 = content.split(separator: "\n\n")
    guard c1.count == 2 else { fatalError() }
    let steps = c1[0].map { $0 }
    let maps = c1[1]
        .split(separator: "\n")
        .map { $0.split(separator: "=").map { $0.trimmingCharacters(in: .whitespaces) } }
        .map {
            let c2 = $0[1].split(separator: ",").map { $0.trimmingCharacters(in: .init([" ", ")", "("])) }
            return (String($0[0]), (String(c2[0]), String(c2[1])))
        }
        .reduce(into: [String: (String, String)]()) {
            $0[$1.0] = $1.1
        }
    return (steps, maps)
}

private func gcd(_ m: Int, _ n: Int) -> Int {
    var a = 0
    var b: Int = max(m, n)
    var r: Int = min(m, n)

    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}

private func lcm(_ m: Int, _ n: Int) -> Int {
    (m * n) / gcd(m, n)
}
