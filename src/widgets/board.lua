app.widgets = app.widgets or {}
app.widgets.board = app.widgets.board or {}
app.widgets.board.padding = 4

require 'src/widgets/bubble'
require 'src/widgets/tile'

-- Too lazy to use Doxygen...
-- create(int size, number width): create a [size]*[size] board with a width of [width].
function app.widgets.board:create(size, width)
    local layer = cc.LayerColor:create(app.res.colours.game_container._4b, width, width)
    layer.data = {}
    local cell_width = (width - app.widgets.board.padding * (size + 1)) / size
    for i = 1, size do
        layer.data[i] = {}
        for j = 1, size do
            local cell = app.widgets.bubble:create(cell_width, app.res.colours.cell._3b)
            cell:setOpacity(app.res.colours.cell._4b.a)
            cell:setPosition(cc.p(
              j * (app.widgets.board.padding + cell_width) - cell_width * 0.5,
              i * (app.widgets.board.padding + cell_width) - cell_width * 0.5))
            layer:addChild(cell, 1, (i - 1) * size + j)
            layer.data[i][j] = 0
        end
    end
    layer.size = size
    layer.cell_width = cell_width
    layer.create_tile = app.widgets.board.create_tile
    layer.empty_cells = app.widgets.board.empty_cells
    layer.gen_random = app.widgets.board.gen_random
    return layer
end

function app.widgets.board:create_tile(num, row, col)
    local tile = app.widgets.tile:create(num, self.cell_width)
    tile:setPosition(cc.p(
      col * (app.widgets.board.padding + self.cell_width) - self.cell_width * 0.5,
      row * (app.widgets.board.padding + self.cell_width) - self.cell_width * 0.5))
    local orig_scale = tile:getScale()
    tile:setScale(0); tile:setOpacity(0)
    tile:runAction(cc.EaseSineOut:create(cc.Spawn:create(
      cc.ScaleTo:create(0.2, orig_scale),
      cc.FadeIn:create(0.2)
    )))
    tile.value = num
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
