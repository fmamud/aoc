function parse_line(line)
    local lines = {}
    for n in line:gmatch("%d+") do
        table.insert(lines, tonumber(n))
    end
    return lines
end

function parse_boards(file)
    local boards, board, eof = {}, {}, 0
    while true do
        local line = file:read("l")

        if not line or line:len() == 0 then
            if #board > 0 then
                table.insert(boards, board)
                board = {}
            end
            eof = eof + 1
        end

        if eof > 1000 then
            break
        end
        
        if line and line:len() > 0 then
            table.insert(board, parse_line(line))
        end
    end
    return boards
end

function show_boards(boards)
    for _, b in pairs(boards) do
        print("board", b)
        for _, bb in pairs(b) do
            print(table.concat(bb, " "))
        end
    end
end

function chunked(numbers, chunk_size)
    local chunk_size = chunk_size or 5
    local offset = 1
    return function()
        while true do
            local chunk = {table.unpack(numbers, offset, (offset + chunk_size) - 1)}
            if #chunk == 0 then
                return nil
            end
            
            offset = offset + chunk_size
            return chunk
        end
    end
end

function check_bingo(seen, board)
    for lidx = 1, #board do
        local column, row = {}, {}
        for ridx = 1, #board[lidx] do
            table.insert(column, board[lidx][ridx])
        end

        for ridx = 1, #board[lidx] do
            table.insert(row, board[ridx][lidx])
        end

        local hequals, vequals = 0, 0
        for nidx, n in ipairs(seen) do
            for tnidx=1, #board do
                local hn, vn = column[tnidx], row[tnidx]
                if n == hn then
                    hequals = hequals + 1
                end

                if n == vn then
                    vequals = vequals + 1
                end
        
                if hequals == 5 or vequals == 5 then
                    return nidx, n, board
                end
            end
        end
    end
end

function is_drawn(window, cn)
    for _, wn in pairs(window) do
        if cn == wn then
            return true
        end
    end
    return false
end

function bingo(file)
    local f <close> = io.open(file)

    local numbers = parse_line(f:read("l"))

    local boards = parse_boards(f)

    local seen = {}

    local board_bingo = {}

    local scores = {}

    for _, n in ipairs(numbers) do
        table.insert(seen, n)
        for board_id, board in pairs(boards) do
            local drawnidx, drawn, board = check_bingo(seen, board)
            if drawn and not board_bingo[board] then
                local unmarked = 0
                for _, column in pairs(board) do
                    for _, cn in pairs(column) do
                        if not is_drawn(seen, cn) then
                            unmarked = unmarked + cn 
                        end
                    end
                end
                local score = unmarked * drawn
                table.insert(scores, score)
                board_bingo[board] = score
            end
        end
    end

    return scores
end

function run(file)
    return bingo(file)[1]
end

function run_part2(file)
    local results = bingo(file)

    return results[#results]
end

assert(run("sample.txt") == 4512)
assert(run_part2("sample.txt") == 1924)