app.widgets = app.widgets or {}
app.widgets.board = app.widgets.board or {}
app.widgets.board.padding = 4

-- Too lazy to use Doxygen...
-- create(int size, number width): create a [size]*[size] board with a width of [width].
function app.widgets.board:create(size, width)
    local layer = cc.LayerColor:create(app.res.colours.game_container._4b, width, width)
    local cell_width = (width - app.widgets.board.padding * (size + 1)) / size
    for i = 1, size do
        for j = 1, size do
            local cell = app.widgets.bubble:create(cell_width, app.res.colours.cell._3b)
            cell:setOpacity(app.res.colours.cell._4b.a)
            cell:setAnchorPoint(cc.p(0, 0))
            cell:setPosition(cc.p(
              j * (app.widgets.board.padding + cell_width) - cell_width,
              i * (app.widgets.board.padding + cell_width) - cell_width))
            layer:addChild(cell, 1, (i - 1) * size + j)
        end
    end
    return layer
end
