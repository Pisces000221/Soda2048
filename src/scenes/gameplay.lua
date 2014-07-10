require 'src/scenes/_soda_base'
require 'src/widgets/bubble'

app.scenes = app.scenes or {}
app.scenes.gameplay = app.scenes.gameplay or {}

function app.scenes.gameplay:create()
    local scene = app.scenes._soda_base:create()
    local bg = cc.LayerColor:create(app.res.colours.background._4b)
    scene:addChild(bg, -1)

    -- the big '2048' in the top-left corner
    local lbl_title = app.label(' 2048', 72, true)
    lbl_title:setColor(app.res.colours.front._3b)
    lbl_title:setAnchorPoint(cc.p(0, 1))
    lbl_title:setPosition(display.normalize(0, 1))
    scene:addChild(lbl_title)

    return scene
end
