int run(String fileName) {
    int horizontalPosition = 0
    int depth = 0
    new File(fileName).eachLine {
        def (cmd, value) = it.split()
        switch (cmd) {
            case "forward":
                horizontalPosition += value as int
                break
            case "down":
                depth += value as int
                break
            case "up":
                depth -= value as int
                break
        }
    }
    return horizontalPosition * depth
}

int runPart2(String fileName) {
    int horizontalPosition = 0
    int depth = 0
    int aim = 0
    new File(fileName).eachLine {
        String[] fields = it.split()
        String cmd = fields[0]
        int value = fields[1] as int
        switch (cmd) {
            case "forward":
                horizontalPosition += value
                depth += aim * value
                break
            case "down":
                aim += value
                break
            case "up":
                aim -= value
                break
        }
    }
    return horizontalPosition * depth
}

assert run("sample.txt.txt") == 150
assert runPart2("sample.txt.txt") == 900