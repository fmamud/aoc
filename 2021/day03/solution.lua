function most_common(report, position)
    return report["0"][position] > report["1"][position] and 0 or 1
end

function least_common(report, position)
    return report["0"][position] > report["1"][position] and 1 or 0
end

function run(file)
    local report = {
        ["0"] = {},
        ["1"] = {}
    }

    for line in io.lines(file) do
        local position = 1
        for digit in line:gmatch("%d") do
            local bucket = report[digit]
            bucket[position] = (bucket[position] or 0) + 1
            position = position + 1
        end
    end

    local most, least  = {}, {}
    for position = 1, #report["0"] do
        table.insert(most, most_common(report, position))
        table.insert(least, least_common(report, position))
    end

    local gamma = tonumber(table.concat(most), 2)
    local epsilon = tonumber(table.concat(least), 2)

    return gamma * epsilon
end

function add_filtered(report, filtered, line, position, target, tie)
    local t = position < #report[tostring(tie)] and target or tie
    if tonumber(line:sub(position, position)) == t then
        table.insert(filtered, line)
    end
end

function extract(data, fn_common, tie, position)
    local report = {
        ["0"] = {},
        ["1"] = {}
    }

    for _, line in ipairs(data) do
        local n = 1
        for digit in line:gmatch("%d") do
            local bucket = report[digit]
            bucket[n] = (bucket[n] or 0) + 1
            n = n + 1
        end
    end
    
    local position = position or 1

    if position > data[1]:len() or #data == 1 then
        return data[1]
    end

    local target = fn_common(report, position)

    local filtered = {}
    for _, line in ipairs(data) do
        add_filtered(report, filtered, line, position, target, tie)
    end

    if #filtered == 0 and position < #report[tostring(tie)] then
        table.move(data, 1, #data, 1, filtered)
    end

    return extract(filtered, fn_common, tie, position + 1)
end

function run_part2(file)

    local data = {}
    for line in io.lines(file) do
        table.insert(data, line)
    end
    
    local co2 = tonumber(extract(data, least_common, 0), 2)
    local oxygen = tonumber(extract(data, most_common, 1), 2)

    return co2 * oxygen
end

assert(run("sample.txt") == 198)
assert(run_part2("sample.txt") == 230)