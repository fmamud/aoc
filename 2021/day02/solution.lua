function run(file)
    local horizontal_position, depth = 0, 0

    for line in io.lines(file) do
        local command, value = line:match("(%w+) (%d+)")

        if command == "forward" then
            horizontal_position = horizontal_position + value
        elseif command == "down" then
            depth = depth + value
        elseif command == "up" then
            depth = depth - value
        end
    end

    return horizontal_position * depth
end

function run_part2(file)
    local horizontal_position, depth, aim = 0, 0, 0

    for line in io.lines(file) do
        local command, value = line:match("(%w+) (%d+)")

        if command == "forward" then
            horizontal_position = horizontal_position + value
            depth = depth + (aim * value)
        elseif command == "down" then
            aim = aim + value
        elseif command == "up" then
            aim = aim - value
        end
    end

    return horizontal_position * depth
end

assert(run("sample.txt") == 150)
assert(run_part2("sample.txt") == 900)