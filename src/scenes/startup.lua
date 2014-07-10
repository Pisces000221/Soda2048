require 'src/scenes/_soda_base'
require 'src/widgets/bubble'

app.scenes = app.scenes or {}
app.scenes.startup = app.scenes.startup or {}

function app.scenes.startup:create()
    local scene = app.scenes._soda_base:create()
    local bg = cc.LayerColor:create(app.res.colours.background._4b);
    scene:addChild(bg, -1)

    

    return scene
end
