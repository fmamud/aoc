function get_data(file)
    local data = {}
    for line in io.lines(file) do
        table.insert(data, line)
    end
    return data
end

function get_stats(data)
    local stats = {}
    for _, value in ipairs(data) do
        local column = 1
        for n in value:gmatch("%d") do
            local container = stats[column] or {}
            local key = tonumber(n)
            container[key] = (container[key] or 0) + 1
            stats[column] = container
            column = column + 1
        end
    end
    return stats
end

function get_common(data)
    local stats = get_stats(data)
    local most_common, least_common = {}, {}
    for i = 1, #stats do
        local column = stats[i]
        table.insert(most_common, column[0] > column[1] and 0 or 1)
        table.insert(least_common, column[0] < column[1] and 0 or 1)
    end
    return most_common, least_common
end

function run(file)
    local data = get_data(file)
    local most_common, least_common = get_common(data)

    local gama = tonumber(table.concat(most_common), 2)
    local epsilon = tonumber(table.concat(least_common), 2)

    return gama * epsilon
end

--For example, to determine the oxygen generator rating value using the same example diagnostic report from above:
--
--Start with all 12 numbers and consider only the first bit of each number. There are more 1 bits (7) than 0 bits (5),
--        so keep only the 7 numbers with a 1 in the first position: 11110, 10110, 10111, 10101, 11100, 10000, and 11001.
--Then, consider the second bit of the 7 remaining numbers: there are more 0 bits (4) than 1 bits (3), so keep only the 4 numbers with a 0
--          in the second position: 10110, 10111, 10101, and 10000.
--In the third position, three of the four numbers have a 1, so keep those three: 10110, 10111, and 10101.
--In the fourth position, two of the three numbers have a 1, so keep those two: 10110 and 10111.
--In the fifth position, there are an equal number of 0 bits and 1 bits (one each). So, to find the oxygen generator rating, keep the number with a 1 in that position: 10111.
--As there is only one number left, stop; the oxygen generator rating is 10111, or 23 in decimal.

function get_lsr(data, position)
    local most_common, least_common = get_common(data)

    local bit = most_common[position]

    local new = {}
    for _, value in ipairs(data) do
        if string.sub(value, position, position) == bit then
            table.insert(new, value)
        end
    end


end

function run_part2(file)
    local oxygen, co2 = get_lsr(get_data(file))

    return oxygen * co2
end

assert(run("sample.txt") == 198)
assert(run_part2("sample.txt") == 230)