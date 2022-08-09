def run(file):
    with open(file) as f:
        increase = 0
        previous = None
        for line in f:
            current = int(line)
            if previous and current > previous:
                increase += 1
            previous = current
        return increase


def run_part2(file):
    with open(file) as f:
        lines = f.read().splitlines()
        start, end = 0, 3
        increase = 0
        previous = None

        while True:
            line = lines[start:end]
            if len(line) < 3:
                break
            current = sum(map(int, line))
            if previous and current > previous:
                increase += 1
            previous = current
            start += 1
            end += 1

        last = sum(map(int, lines[-3:]))

        if last > previous:
            increase += 1

        return increase


if __name__ == '__main__':
    assert run("sample.txt") == 7
    assert run_part2("sample.txt") == 5
