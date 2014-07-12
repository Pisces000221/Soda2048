app.widgets = app.widgets or {}
app.widgets.board = app.widgets.board or {}
app.widgets.board.padding = 4
app.widgets.board.tile_move_dur = 0.1

require 'src/data/js_array'
require 'src/widgets/bubble'
require 'src/widgets/tile'

-- A game board. Contains a grid and tiles.
-- For problems about tags, see @ref board.cell_tag and @ref board.tile_tag.

-- Too lazy to use Doxygen...
-- create(int size, number width): create a [size]*[size] board with a width of [width].
function app.widgets.board:create(size, width)
    local layer = cc.LayerColor:create(app.res.colours.game_container._4b, width, width)
    local cell_width = (width - app.widgets.board.padding * (size + 1)) / size
    -- data that is used by the code below
    layer.size = size
    layer.cell_width = cell_width
    layer.cell_tag = app.widgets.board.cell_tag
    layer.cell_pos = app.widgets.board.cell_pos
    for i = 1, size do
        for j = 1, size do
            local cell = app.widgets.bubble:create(cell_width, app.res.colours.cell._3b)
            cell:setOpacity(app.res.colours.cell._4b.a)
            cell:setPosition(layer:cell_pos(i, j))
            layer:addChild(cell, 1, layer:cell_tag(i, j))
        end
    end
    layer.score = 0
    layer.tile_tag = app.widgets.board.tile_tag
    layer.get_value = app.widgets.board.get_value
    layer.get_tile = app.widgets.board.get_tile
    layer.create_tile = app.widgets.board.create_tile
    layer.empty_cells = app.widgets.board.empty_cells
    layer.gen_random = app.widgets.board.gen_random
    layer.move = app.widgets.board.move
    layer._findFarthestPosition = app.widgets.board._findFarthestPosition
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

function app.widgets.board:get_value(row, col)
    if row <= 0 or row > self.size or col <= 0 or col > self.size then return -1 end
    local tile = self:getChildByTag(self:tile_tag(row, col))
    if tile then return tile.value else return 0 end
end
function app.widgets.board:get_tile(row, col)
    if row <= 0 or row > self.size or col <= 0 or col > self.size then return nil end
    return self:getChildByTag(self:tile_tag(row, col))
end

-- string anim_type: 'newly_gen' or 'merged'
function app.widgets.board:create_tile(value, row, col, anim_type)
    local tile = app.widgets.tile:create(value, self.cell_width)
    tile:setPosition(self:cell_pos(row, col))
    local orig_scale = tile:getScale()
    if anim_type == 'newly_gen' then
        tile:setScale(0); tile:setOpacity(0)
        tile:runAction(cc.Sequence:create(
          cc.DelayTime:create(app.widgets.board.tile_move_dur),
          cc.EaseSineOut:create(cc.Spawn:create(
            cc.ScaleTo:create(0.2, orig_scale),
            cc.FadeIn:create(0.2)
        ))))
    elseif anim_type == 'merged' then
        tile:setVisible(false)
        tile:runAction(cc.Sequence:create(
          cc.DelayTime:create(app.widgets.board.tile_move_dur),
          cc.Show:create(),
          cc.ScaleBy:create(0.06, 1.2),
          cc.ScaleBy:create(0.06, 10/12)
        ))
    end
    tile:setTag(self:tile_tag(row, col))
    return tile
end

function app.widgets.board:empty_cells()
    local ret = {}
    for i = 1, self.size do
        for j = 1, self.size do
            if self:get_value(i, j) == 0 then ret[#ret + 1] = { row = i, col = j } end
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
    -- see: gabrielecirulli/2048/js/game_manager.js (71)
    local value = 2
    if math.random(1, 100) > 90 then value = 4 end
    local tile = self:create_tile(value, row, col, 'newly_gen')
    self:addChild(tile, 3)
    return row, col
end

function app.widgets.board:move(direction)
    local _vectors = {
        [4] = cc.p(0, 1), [3] = cc.p(0, -1), [2] = cc.p(-1, 0), [1] = cc.p(1, 0)
    }
    local vector = _vectors[direction]
    local traversals = { x = app.data.js_array.new(), y = app.data.js_array.new() }
    local moved = false
    -- build traversals
    for pos = 1, self.size do
        traversals.x:push(pos)
        traversals.y:push(pos)
    end
    if vector.x == 1 then traversals.x = traversals.x:reverse() end
    if vector.y == 1 then traversals.y = traversals.y:reverse() end
    -- everything can be merged (travis-ci: build succeeded) <-- freaked out
    local all_tiles = self:getChildren()
    for i = 1, #all_tiles do all_tiles[i].is_merged = false end
    -- move tiles
    for i = 1, #traversals.x do
        local x = traversals.x[i]
        for j = 1, #traversals.y do
            local y = traversals.y[j]
            local tile = self:get_tile(x, y)
            if tile then
                local orig_pos = cc.p(tile:getPosition())
                local new_pos
                local positions = self:_findFarthestPosition(x, y, vector)
                local second = self:get_tile(positions.second.x, positions.second.y)
                if second and second.value == tile.value and not second.is_merged then
                    print(string.format('merged: (%d, %d) - (%d, %d)', x, y, positions.second.x, positions.second.y))
                    local merged = self:create_tile(
                      tile.value * 2, positions.second.x, positions.second.y, 'merged')
                    merged.is_merged = true
                    self:addChild(merged, 3)
                    new_pos = self:cell_pos(positions.second.x, positions.second.y)
                    -- bye bye, old tiles!
                    tile:runAction(cc.Sequence:create(
                      cc.MoveTo:create(app.widgets.board.tile_move_dur, new_pos),
                      cc.RemoveSelf:create()))
                    second:runAction(cc.Sequence:create(
                      cc.DelayTime:create(app.widgets.board.tile_move_dur),
                      cc.RemoveSelf:create()))
                    tile:setTag(-1); second:setTag(-1)
                    -- get score
                    self.score = self.score + tile.value * 2
                else
                    new_pos = self:cell_pos(positions.farthest.x, positions.farthest.y)
                    tile:runAction(cc.MoveTo:create(app.widgets.board.tile_move_dur, new_pos))
                    tile:setTag(self:tile_tag(positions.farthest.x, positions.farthest.y))
                end
                if new_pos.x ~= orig_pos.x or new_pos.y ~= orig_pos.y then
                    moved = true
                end
            end
        end
    end
    if moved then print(string.format('random: %d, %d', self:gen_random())) end
    for i = 1, self.size do
        local s = ''
        for j = 1, self.size do s = s .. self:get_value(i, j) .. ' ' end
        print(s)
    end
    print('')
end

function app.widgets.board:_findFarthestPosition(row, col, vector)
    local previous_x, previous_y
    repeat
        previous_x = row; previous_y = col
        row = previous_x + vector.x; col = previous_y + vector.y
    until row <= 0 or row > self.size or col <= 0 or col > self.size
      or self:get_value(row, col) > 0
    return { farthest = cc.p(previous_x, previous_y), second = cc.p(row, col) }
end
