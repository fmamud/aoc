function run(file)
    local increase, previous = 0, nil
    for line in io.lines(file) do
        local n = tonumber(line)
        if previous and n > previous then
            increase = increase + 1
        end
        previous = n 
    end
    return increase
end

function sum(window)
    local total = 0
    for _, value in ipairs(window) do
        total = total + value
    end
    return total
end

function run_part2(file)
    local increase, previous = 0, nil
    local f = io.open(file)

    local window = {
        f:read("n"),
        f:read("n"),
        f:read("n")
    }

    repeat
        local last = f:read("n")

        local next_window = {
            window[2],
            window[3],
            last
        }

        if sum(next_window) > sum(window) then
            increase = increase + 1
        end

        table.move(next_window, 1, #next_window, 1, window)
    until not last
    
    return increase
end

assert(run("sample.txt") == 7)
assert(run_part2("sample.txt") == 5)