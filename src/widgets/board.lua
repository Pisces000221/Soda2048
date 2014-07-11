app.widgets = app.widgets or {}
app.widgets.board = app.widgets.board or {}
app.widgets.board.padding = 4

require 'src/widgets/bubble'
require 'src/widgets/tile'

-- A game board. Contains a grid and tiles.
-- For problems about tags, see @ref board.cell_tag and @ref board.tile_tag.

-- Too lazy to use Doxygen...
-- create(int size, number width): create a [size]*[size] board with a width of [width].
function app.widgets.board:create(size, width)
    local layer = cc.LayerColor:create(app.res.colours.game_container._4b, width, width)
    layer.data = {}
    local cell_width = (width - app.widgets.board.padding * (size + 1)) / size
    -- data that is used by the code below
    layer.size = size
    layer.cell_width = cell_width
    layer.cell_tag = app.widgets.board.cell_tag
    layer.cell_pos = app.widgets.board.cell_pos
    for i = 1, size do
        layer.data[i] = {}
        for j = 1, size do
            local cell = app.widgets.bubble:create(cell_width, app.res.colours.cell._3b)
            cell:setOpacity(app.res.colours.cell._4b.a)
            cell:setPosition(layer:cell_pos(i, j))
            layer:addChild(cell, 1, layer:cell_tag(i, j))
            layer.data[i][j] = 0
        end
    end
    layer.tile_tag = app.widgets.board.tile_tag
    layer.create_tile = app.widgets.board.create_tile
    layer.empty_cells = app.widgets.board.empty_cells
    layer.gen_random = app.widgets.board.gen_random
    layer.move = app.widgets.board.move
    return layer
end

function app.widgets.board:cell_tag(row, col)
    return (row - 1) * self.size + col
end
function app.widgets.board:tile_tag(row, col)
    return (row - 1) * self.size + col + self.size * self.size
end
function app.widgets.board:cell_pos(row, col)
    return cc.p(
      col * (app.widgets.board.padding + self.cell_width) - self.cell_width * 0.5,
      row * (app.widgets.board.padding + self.cell_width) - self.cell_width * 0.5)
end

function app.widgets.board:create_tile(num, row, col)
    local tile = app.widgets.tile:create(num, self.cell_width)
    tile:setPosition(self:cell_pos(row, col))
    local orig_scale = tile:getScale()
    tile:setScale(0); tile:setOpacity(0)
    tile:runAction(cc.EaseSineOut:create(cc.Spawn:create(
      cc.ScaleTo:create(0.2, orig_scale),
      cc.FadeIn:create(0.2)
    )))
    tile.value = num
    tile:setTag(self:tile_tag(row, col))
    return tile
end

function app.widgets.board:empty_cells()
    local ret = {}
    for i = 1, self.size do
        for j = 1, self.size do
            if self.data[i][j] == 0 then ret[#ret + 1] = { row = i, col = j } end
        end
    end
    return ret
end

function app.widgets.board:gen_random()
    local empty_cells = self:empty_cells()
    if #empty_cells == 0 then return end
    local idx = math.random(1, #empty_cells)
    local row, col = empty_cells[idx].row, empty_cells[idx].col
    -- generate a number of 2 or 4
    local tile = self:create_tile(math.random(1, 2) * 2, row, col);
    self.data[row][col] = tile.value
    self:addChild(tile)
end

function app.widgets.board:move(direction)
    local tiles, newpos = {}, {}
    local mergestate = {}
    local curtile
    local MERGED = 3
    local INCREASED = 2
    local NONE = 0
    -- move & merge tile data
    for i = 1, self.size do
        tiles[i], newpos[i], mergestate[i] = {}, {}, {}
        for j = 1, self.size do
            curtile = self.data[i][j]
            if curtile > 0 then -- not an empty cell
                if tiles[i][#tiles[i]] == curtile then  -- merge two same tiles
                    tiles[i][#tiles[i]] = curtile * 2
                    mergestate[i][j] = MERGED
                    for k = j - 1, 1, -1 do
                        if self.data[i][k] > 0 and mergestate[i][k] ~= MERGED then
                            mergestate[i][k] = INCREASED; break
                        end
                    end
                else
                    tiles[i][#tiles[i] + 1] = curtile
                    mergestate[i][j] = NONE
                end
                newpos[i][j] = #tiles[i]
            else    -- an empty cell. fill that with an unused value
                newpos[i][j] = -1
            end
        end
    end
    -- fill empty cells with zero
    for i = 1, self.size do
        for j = 1, self.size do self.data[i][j] = tiles[i][j] or 0 end
    end
    for i = 1, self.size do
        local s = ''
        for j = 1, self.size do s = s .. tostring(mergestate[i][j]) .. ' ' end
        print(s)
    end
    -- move real tiles (sprites or bubbles)
    for i = 1, self.size do
        for j = 1, self.size do
            local curtile = self:getChildByTag(self:tile_tag(i, j))
            if curtile ~= nil then
                local maybe_remove_action
                if mergestate[i][j] == MERGED then maybe_remove_action = cc.RemoveSelf:create()
                elseif mergestate[i][j] == INCREASED then maybe_remove_action = cc.CallFunc:create(function()
                  curtile:set_number(self.data[i][newpos[i][j]])
                end)
                else maybe_remove_action = cc.DelayTime:create(0) end
                curtile:runAction(cc.Sequence:create(
                  cc.MoveTo:create(0.12, self:cell_pos(i, newpos[i][j])),
                  maybe_remove_action))
                curtile:setTag(self:tile_tag(i, newpos[i][j]))
            end
        end
    end
    logtable(self.data)
end
