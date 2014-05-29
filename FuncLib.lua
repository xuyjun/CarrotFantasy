function grid(_row, _col) 
    return {row = _row, col = _col}
end

function posToGrid(position)
    local row = math.floor(position.y / GRID_WIDTH) + 1
    local col = math.floor(position.x / GRID_WIDTH) + 1
    return grid(row, col)
end

function gridToCenter(grid)
    local x = (grid.col - 0.5) * GRID_WIDTH
    local y = (grid.row - 0.5) * GRID_WIDTH
    return cc.p(x, y)
end

function posToCenter(position)
    return gridToCenter(posToGrid(position))
end

function initArray(row, col, value)
    local array = {}
    for i = 1, row do
        array[i] = {}
        for j = 1, col do
            array[i][j] = value
        end
    end
    return array
end

function monsterData(_number, _hp, _name)
    local t = {
        NUMBER = _number,
        HP = _hp,
        NAME = _name
    }
    return t
end